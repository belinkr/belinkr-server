# encoding: utf-8
require_relative '../../Tinto/Context'

module Belinkr
  module DeleteInvitation
    class Context
      include Tinto::Context

      def initialize(arguments)
        @enforcer     = arguments.fetch(:enforcer)
        @actor        = arguments.fetch(:actor)
        @invitation   = arguments.fetch(:invitation)
        @invitations  = arguments.fetch(:invitations)
      end # initialize

      def call
        enforcer.authorize(actor, :delete)
        invitation.delete
        invitations.delete invitation

        will_sync invitation, invitations
      end # call

      private

      attr_reader :enforcer, :actor, :invitation, :invitations
    end # Context
  end # DeleteInvitation
end # Belinkr

