# encoding: utf-8
require_relative '../../Tinto/Context'

module Belinkr
  module AcceptInvitationToWorkspace
    class Context
      include Tinto::Context

      def initialize(arguments)
        @actor                        = arguments.fetch(:actor)
        @enforcer                     = arguments.fetch(:enforcer)
        @workspace                    = arguments.fetch(:workspace)
        @invitation                   = arguments.fetch(:invitation)
        @tracker                      = arguments.fetch(:tracker)
        @memberships_as_invited       = arguments.fetch(:memberships_as_invited)
        @memberships_as_collaborator  = arguments
                                          .fetch(:memberships_as_collaborator)
      end #initialize

      def call
        enforcer                    .authorize(actor, :accept)
        invitation                  .accept
        workspace                   .increment_user_counter

        tracker                     .delete(:invited, actor.id)
        tracker                     .add(:collaborator, actor.id)

        memberships_as_invited      .delete(workspace)
        memberships_as_collaborator .add(workspace)

        will_sync invitation, workspace, tracker, memberships_as_invited,
                  memberships_as_collaborator
      end #call

      private

      attr_reader :enforcer, :actor, :workspace, :invitation, :tracker, 
                  :memberships_as_invited, :memberships_as_collaborator
    end # Context
  end # AcceptInvitationToWorkspace
end # Belinkr

