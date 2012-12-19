# encoding: utf-8
require_relative '../../Resources/User/Member'
require_relative '../../Resources/Entity/Member'
require_relative '../../Resources/Profile/Member'
require_relative '../../Resources/Profile/Enforcer'
require_relative '../../Resources/Profile/Collection'

module Belinkr
  module GetUser
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
          member:       profile,
          enforcer:     enforcer
        }
      end #prepare

      private

      attr_reader :payload, :actor, :actor_profile, :entity

      def profile
        @user ||= User::Member.new(id: payload.fetch('user_id')).fetch
        @user.profile_for(entity)
      end #member

      def enforcer
        Profile::Enforcer.new(profile)
      end #enforcer

      def scope
        { entity_id: entity.id }
      end #scope
    end # Request
  end # GetUser
end # Belinkr

