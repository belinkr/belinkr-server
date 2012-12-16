# encoding: utf-8
require_relative '../../Resources/User/Member'
require_relative '../../Resources/Profile/Member'
require_relative '../../Resources/Follower/Enforcer'
require_relative '../../Resources/Follower/Collection'
require_relative '../../Resources/Following/Collection'

module Belinkr
  module UnfollowUserInEntity
    class Request
      def initialize(arguments)
        @payload        = arguments.fetch(:payload)
        @actor          = arguments.fetch(:actor)
        @actor_profile  = arguments.fetch(:actor_profile)
        @entity         = arguments.fetch(:entity)
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
        }
      end #prepare

      private

      attr_reader :payload, :actor, :actor_profile, :entity

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
          user_id:    followed.id,
          entity_id:  entity.id
        )
      end #followers

      def following
        Following::Collection.new(
          user_id:    actor.id,
          entity_id:  entity.id
        )
      end #following
    end # Request
  end # UnfollowUserInEntity
end # Belinkr

