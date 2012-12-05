# encoding: utf-8
require_relative '../../Resources/User/Member'
require_relative '../../Resources/Profile/Member'
require_relative '../../Resources/Follower/Enforcer'
require_relative '../../Resources/Follower/Collection'
require_relative '../../Resources/Following/Collection'
require_relative '../../Resources/Status/Collection'

module Belinkr
  module FollowUserInEntity
    class Request
      def initialize(payload, actor, actor_profile, entity)
        @payload        = payload
        @actor          = actor
        @actor_profile  = actor_profile
        @entity         = entity
      end #initialize

      def prepare
        {
          enforcer:           enforcer,
          actor:              actor,
          actor_profile:      actor_profile,
          followed:           followed,
          followed_profile:   followed_profile,
          followers:          followers,
          following:          following,
          entity:             entity,
          actor_timeline:     actor_timeline,
          latest_statuses:    latest_statuses
        }
      end #prepare

      private

      attr_accessor :payload, :actor, :actor_profile, :entity

      def enforcer
        Follower::Enforcer.new(followed)
      end #enforcer

      def followed
        @followed ||= User::Member.new(id: payload.fetch('followed_id')).fetch
      end #followed

      def followed_profile
        profile_id =  followed.profiles.select { |profile| 
          profile.entity_id == entity.id 
        }.first.id

        Profile::Member.new(
          id:         profile_id,   
          user_id:    payload.fetch('followed_id'),
          entity_id:  entity.id
        ).fetch
      end #followed_profile

      def followers
        Follower::Collection.new(
          profile_id: followed_profile.id,
          entity_id:  entity.id
        )
      end #followers

      def following
        Following::Collection.new(
          profile_id: actor_profile.id,
          entity_id:  entity.id
        )
      end #following

      def actor_timeline
        Status::Collection.new(
          kind:     'general',
          context:  actor_profile
        )
      end #actor_timeline

      def latest_statuses
        @latest_statuses ||= Status::Collection.new(
          kind:     'own',
          context:  followed_profile
        ).page
      end #latest_statuses
    end # Request
  end # FollowUserInEntity
end # Belinkr

