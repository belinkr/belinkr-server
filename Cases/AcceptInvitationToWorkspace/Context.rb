# encoding: utf-8
require 'Tinto/Context'

module Belinkr
  module AcceptInvitationToWorkspace
    class Context
      include Tinto::Context

      def initialize(arguments)
        @actor      = arguments.fetch(:actor)
        @enforcer   = arguments.fetch(:enforcer)
        @workspace  = arguments.fetch(:workspace)
        @invitation = arguments.fetch(:invitation)
        @tracker    = arguments.fetch(:tracker)
      end #initialize

      def call
        enforcer    .authorize(actor, :accept)
        invitation  .accept
        workspace   .increment_user_counter
        tracker     .track_collaborator(workspace, actor)

        will_sync invitation, workspace, tracker
      end #call

      private

      attr_reader :enforcer, :actor, :workspace, :invitation, :tracker
    end # Context
  end # AcceptInvitationToWorkspace
end # Belinkr

