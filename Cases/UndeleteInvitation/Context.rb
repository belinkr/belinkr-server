# encoding: utf-8
require 'Tinto/Context'

module Belinkr
  module UndeleteInvitation
    class Context
      include Tinto::Context

      def initialize(arguments)
        @enforcer     = arguments.fetch(:enforcer)
        @actor        = arguments.fetch(:actor)
        @invitation   = arguments.fetch(:invitation)
        @invitations  = arguments.fetch(:invitations)
      end #initialize

      def call
        enforcer.authorize(actor, :undelete)
        invitation.undelete
        invitations.add(invitation)

        will_sync invitation, invitations
      end #call

      private

      attr_reader :enforcer, :actor, :invitation, :invitations, :entity
    end # Context
  end # UndeleteInvitation
end # Belinkr

