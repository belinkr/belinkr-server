# encoding: utf-8
require_relative '../../Resources/User/Enforcer'

module Belinkr
  module EditUserProfile
    class Request
      def initialize(payload, actor, actor_profile, entity)
        @payload        = payload
        @actor          = actor
        @actor_profile  = actor_profile
        @entity         = entity
      end #initialize

      def prepare
        {
          enforcer:         enforcer,
          actor:            actor,
          user:             actor,
          user_changes:     payload,
          profile:          actor_profile,
          profile_changes:  payload
        }
      end #prepare

      private

      attr_reader :payload, :actor, :actor_profile, :entity

      def enforcer
        User::Enforcer.new(actor)
      end #enforcer
    end # Request
  end # EditUserProfile
end # Belinkr

