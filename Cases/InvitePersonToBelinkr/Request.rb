# encoding: utf-8
require_relative '../../Resources/Invitation/Member'
require_relative '../../Resources/Invitation/Collection'
require_relative '../../Resources/Message/Member'

module Belinkr
  module InvitePersonToBelinkr
    class Request
      def initialize(payload, actor, entity)
        @payload  = payload
        @actor    = actor
        @entity   = entity
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
        Invitation::Member.new(payload)
      end #invitation

      def invitations
        Invitation::Collection.new
      end #invitations

      def message
        Message::Member.new
      end #message
    end # Request
  end # InvitePersonToBelinkr
end # Belinkr

