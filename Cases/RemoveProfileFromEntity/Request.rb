# encoding: utf-8
require_relative '../../Resources/User/Member'
require_relative '../../Resources/Entity/Member'
require_relative '../../Resources/Profile/Member'
require_relative '../../Resources/Profile/Collection'

module Belinkr
  module RemoveProfileFromEntity
    class Request
      def initialize(arguments)
        @payload        = arguments.fetch(:payload)
        @actor          = arguments.fetch(:actor)
        @entity         = arguments.fetch(:entity)
        @actor_profile  = arguments.fetch(:actor_profile)
      end #initialize

      def prepare
        {
          actor:        actor,
          user:         user,
          enforcer:     enforcer,
          profile:      user.profile_for(entity),
          profiles:     profiles
        }
      end #prepare

      private

      attr_reader :payload, :actor, :actor_profile, :entity

      def user
        User::Member.new(id: payload.fetch('user_id')).fetch
      end #user

      def enforcer
        User::Enforcer.new(user)
      end #enforcer

      def profiles
        Profile::Collection.new(scope)
      end #profiles

      def scope
        { entity_id: entity.id }
      end #scope
    end # Request
  end # RemoveProfileFromEntity
end # Belinkr

