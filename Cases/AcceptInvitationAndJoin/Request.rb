# encoding: utf-8
require_relative '../../Resources/User/Member'
require_relative '../../Resources/Entity/Member'
require_relative '../../Resources/Invitation/Member'
require_relative '../../Resources/Profile/Member'
require_relative '../../Resources/Profile/Collection'

module Belinkr
  module AcceptInvitationAndJoin
    class Request
      def initialize(arguments)
        @payload  = arguments.fetch(:payload)
      end #initialize

      def prepare
        {
          actor:        actor,
          invitation:   invitation,
          entity:       entity,
          profile:      profile,
          profiles:     profiles
        }
      end #prepare

      private

      attr_reader :payload

      def actor
        User::Member.new(payload)
      end #actor

      def invitation
        @invitation ||= 
          Invitation::Member.new(id: payload.fetch('invitation_id')).fetch
      end #invitation

      def entity
        Entity::Member.new(id: invitation.entity_id).fetch
      end #entity

      def profile
        Profile::Member.new(payload.merge scope)
      end #profile

      def profiles
        Profile::Collection.new(scope)
      end #profiles

      def scope
        { entity_id: entity.id }
      end #scope
    end # Request
  end # AcceptInvitationAndJoin
end # Belinkr

