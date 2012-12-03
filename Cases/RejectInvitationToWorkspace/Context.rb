# encoding: utf-8
require 'Tinto/Context'

module Belinkr
  module RejectInvitationToWorkspace
    class Context
      include Tinto::Context

      def initialize(arguments)
        @actor      = arguments.fetch(:actor)
        @workspace  = arguments.fetch(:workspace)
        @enforcer   = arguments.fetch(:enforcer)
        @invitation = arguments.fetch(:invitation)
        @tracker    = arguments.fetch(:tracker)
      end #initialize

      def call
        enforcer    .authorize(actor, :reject)
        invitation  .reject
        tracker     .untrack_invitation(workspace, actor, invitation)

        will_sync invitation, tracker
      end #call

      private

      attr_reader :actor, :workspace, :enforcer, :invitation, :tracker
    end # Context
  end # RejectInvitationToWorkspace
end # Belinkr

