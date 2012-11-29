# encoding: utf-8
require 'Tinto/Context'

module Belinkr
  module AcceptAutoinvitationToWorkspace
    class Context
      include Tinto::Context

      def initialize(arguments)
        @actor          = arguments.fetch(:actor)
        @enforcer       = arguments.fetch(:enforcer)
        @workspace      = arguments.fetch(:workspace)
        @autoinvitation = arguments.fetch(:autoinvitation)
        @autoinvited    = arguments.fetch(:autoinvited)
        @tracker        = arguments.fetch(:tracker)
      end #initialize

      def call
        enforcer        .authorize(actor, :accept)
        autoinvitation  .accept
        workspace       .increment_user_counter
        tracker         .assign_role(workspace, autoinvited, :collaborator)

        will_sync autoinvitation, workspace, tracker
      end #call

      private

      attr_reader :enforcer, :actor, :workspace, :autoinvitation, :autoinvited,
                  :tracker
    end # Context
  end # AcceptAutoinvitationToWorkspace
end # Belinkr

