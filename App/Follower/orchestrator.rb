# encoding: utf-8
require_relative 'enforcer'
require_relative 'collection'
require_relative '../following/collection'
require_relative '../status/collection'
require_relative '../activity/collection'  
require_relative '../xmpp/scheduler'

module Belinkr
  module Follower
    class Orchestrator
      def initialize(actor)
        @actor = actor
      end

      def read(user)
        Enforcer.authorize @actor, :read, user
        user
      end

      def collection(users)
        Enforcer.authorize @actor, :collection, users
        users
      end

      def create(followed)
        Enforcer.authorize @actor, :create, followed
        activity  = Activity::Member.new(
          actor:      @actor,
          action:     'follow', 
          object:     followed,
          entity_id:  followed.entity_id
        ).save

        latest = latest_statuses_from(followed)
        XMPP::Scheduler.new(@actor.credential)
          .add_contact(followed.credential)
        $redis.multi do
          followers_for(followed).add @actor
          following_for(@actor).add followed
          activities_for(@actor).add activity
          timeline_for(@actor).merge latest
        end

        followed
      end #create

      def delete(followed)
        Enforcer.authorize @actor, :delete, followed
        XMPP::Scheduler.new(@actor.credential)
          .remove_contact(followed.credential)
 
        $redis.multi do
          followers_for(followed).remove @actor
          following_for(@actor).remove followed
        end

        followed
      end #delete

      private

      def followers_for(user)
        Follower::Collection.new(user_id: user.id, entity_id: user.entity_id)
      end

      def following_for(user)
        Following::Collection.new(user_id: user.id, entity_id: user.entity_id)
      end

      def timeline_for(user)
        Status::Collection.new(
          user_id:    user.id,
          entity_id:  user.entity_id,
          kind:       'general'
        )
      end

      def latest_statuses_from(user)
        Status::Collection.new(
          user_id:    user.id,
          entity_id:  user.entity_id,
          kind:       'own'
        ).page(0).to_a
      end

      def activities_for(user)
        Activity::Collection.new(entity_id: user.entity_id)
      end
    end # Orchestrator
  end # Follow
end # Belinkr
