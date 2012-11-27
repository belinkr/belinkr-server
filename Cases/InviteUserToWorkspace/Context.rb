# encoding: utf-8
require 'Tinto/Context'

module Belinkr
  module InviteUserToWorkspace
    class Context
      include Tinto::Context

      def initialize(arguments)
        @actor                  = arguments.fetch(:actor)
        @invited                = arguments.fetch(:invited)
        @enforcer               = arguments.fetch(:enforcer)
        @workspace              = arguments.fetch(:workspace)
        @invitation             = arguments.fetch(:invitation)
        @invitations            = arguments.fetch(:invitations)
        @tracker                = arguments.fetch(:tracker)
        @memberships_as_invited = arguments.fetch(:memberships_as_invited)
      end #initialize

      def call
        enforcer                .authorize(actor, :invite)
        invitation              .link_to(
                                  inviter:    actor,
                                  invited:    invited,
                                  workspace:  workspace
                                )
        invitations             .add(invitation)
        tracker                 .add(:invited, actor.id)
        memberships_as_invited  .add(workspace)

        will_sync invitations, invitation, tracker, memberships_as_invited
      end #call

      private

      attr_reader :actor, :invited, :enforcer, :workspace, :invitation,
                  :invitations, :tracker, :memberships_as_invited
    end # Context
  end # InviteUserToWorkspace
end # Belinkr

