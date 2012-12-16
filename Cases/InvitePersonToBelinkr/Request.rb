# encoding: utf-8
require_relative '../../Resources/Invitation/Member'
require_relative '../../Resources/Invitation/Collection'
require_relative '../../Resources/Message/Member'

module Belinkr
  module InvitePersonToBelinkr
    class Request
      def initialize(arguments)
        @payload  = arguments.fetch(:payload)
        @actor    = arguments.fetch(:actor)
        @entity   = arguments.fetch(:entity)
      end #initialize

      def prepare
        {
          actor:        actor,
          invitation:   invitation,
          invitations:  invitations,  
          entity:       entity,
          message:      message
        }
      end #prepare

      private

      attr_reader :payload, :actor, :entity

      def invitation
        Invitation::Member.new(payload.merge(scope))
      end #invitation

      def invitations
        Invitation::Collection.new(entity_id: entity.id)
      end #invitations

      def message
        Message::Member.new
      end #message

      def scope
        { entity_id: entity.id, inviter_id: actor.id }
      end #scope
    end # Request
  end # InvitePersonToBelinkr
end # Belinkr

