# encoding: utf-8
require 'Tinto/Context'

module Belinkr
  module InviteUserToWorkspace
    class Context
      include Tinto::Context

      def initialize(arguments)
        @actor        = arguments.fetch(:actor)
        @invited      = arguments.fetch(:invited)
        @enforcer     = arguments.fetch(:enforcer)
        @workspace    = arguments.fetch(:workspace)
        @invitation   = arguments.fetch(:invitation)
        @invitations  = arguments.fetch(:invitations)
        @tracker      = arguments.fetch(:tracker)
      end #initialize

      def call
        enforcer      .authorize(actor, :invite, invited)
        invitation    .link_to(
                        inviter:    actor,
                        invited:    invited,
                        workspace:  workspace
                      )
        invitations   .add(invitation)
        tracker       .track_invitation(workspace, invited, invitation)

        will_sync invitations, invitation, tracker
      end #call

      private

      attr_reader :actor, :invited, :enforcer, :workspace, :invitation,
                  :invitations, :tracker
    end # Context
  end # InviteUserToWorkspace
end # Belinkr

