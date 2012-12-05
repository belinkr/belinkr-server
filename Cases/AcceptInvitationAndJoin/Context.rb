# encoding: utf-8
require_relative '../CreateProfileInEntity/Context'
require_relative '../RegisterActivity/Context'
require 'Tinto/Context'

module Belinkr
  module AcceptInvitationAndJoin
    class Context
      include Tinto::Context

      attr_writer :create_profile_context, :register_activity_context

      def initialize(arguments)
        @actor      = arguments.fetch(:actor)
        @invitation = arguments.fetch(:invitation)
        @entity     = arguments.fetch(:entity)
        @profile    = arguments.fetch(:profile)
        @profiles   = arguments.fetch(:profiles)
      end #initialize

      def call
        invitation.accept
        create_profile_context.call

        will_sync invitation, create_profile_context
      end #call

      def create_profile_context
        @create_profile_context ||= CreateProfileInEntity::Context.new(
          actor:      actor,
          profile:    profile,
          profiles:   profiles,
          entity:     entity
        )
      end #create_profile_context

      def register_activity_context
        @register_activity_context ||= RegisterActivity::Context.new(
          actor:      actor, 
          action:     'accept',
          object:     invitation,
          entity_id:  entity.id
        )
      end #register_activity_context

      private

      attr_reader :actor, :invitation, :entity, :profile, :profiles
    end # Context
  end # AcceptInvitationAndJoin
end # Belinkr

