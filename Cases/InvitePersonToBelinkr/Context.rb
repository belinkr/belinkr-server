# encoding: utf-8
require 'Tinto/Context'
require_relative '../RegisterActivity/Context'

module Belinkr
  module InvitePersonToBelinkr
    class Context
      include Tinto::Context

      attr_writer :register_activity_context

      def initialize(arguments)
        @actor        = arguments.fetch(:actor)
        @invitation   = arguments.fetch(:invitation)
        @invitations  = arguments.fetch(:invitations)
        @entity       = arguments.fetch(:entity)
        @message      = arguments.fetch(:message)
      end # initialize

      def call
        invitation.link_to(actor)
        invitations.add(invitation)
        message.prepare(:invitation_for, actor, invitation, entity)

        register_activity_context.call

        will_sync invitation, invitations, message, register_activity_context
      end #call

      def register_activity_context
        @register_activity_context || RegisterActivity::Context.new(
          actor:      actor, 
          action:     'invite', 
          # Invited person doesn't have User::Member yet
          object:     invitation.invited_name,
          entity_id:  entity.id
        )
      end #register_activity_context

      private

      attr_reader :actor, :entity, :invitation, :invitations, :message
    end # Context
  end # InvitePersonToBelinkr
end # Belinkr

