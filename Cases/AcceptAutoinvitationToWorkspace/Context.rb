# encoding: utf-8
# encoding: utf-8
require 'Tinto/Context'

module Belinkr
  module AcceptAutoinvitationToWorkspace
    class Context
      include Tinto::Context

      def initialize(arguments)
        @actor                        = arguments.fetch(:actor)
        @enforcer                     = arguments.fetch(:enforcer)
        @workspace                    = arguments.fetch(:workspace)
        @autoinvitation               = arguments.fetch(:autoinvitation)
        @tracker                      = arguments.fetch(:tracker)
        @memberships_as_autoinvited   = arguments
                                          .fetch(:memberships_as_autoinvited)
        @memberships_as_collaborator  = arguments
                                          .fetch(:memberships_as_collaborator)
      end #initialize

      def call
        enforcer                    .authorize(actor, :accept)
        autoinvitation              .accept
        workspace                   .increment_user_counter

        tracker                     .delete(:autoinvited, actor.id)
        tracker                     .add(:collaborator, actor.id)

        memberships_as_autoinvited  .delete(workspace)
        memberships_as_collaborator .add(workspace)

        will_sync autoinvitation, workspace, tracker, 
                  memberships_as_autoinvited, memberships_as_collaborator
      end #call

      private

      attr_reader :enforcer, :actor, :workspace, :autoinvitation, :tracker,
                  :memberships_as_autoinvited, :memberships_as_collaborator
    end # Context
  end # AcceptAutoinvitationToWorkspace
end # Belinkr

