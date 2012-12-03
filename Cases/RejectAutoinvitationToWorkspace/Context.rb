# encoding: utf-8
require 'Tinto/Context'

module Belinkr
  module RejectAutoinvitationToWorkspace
    class Context
      include Tinto::Context

      def initialize(arguments)
        @actor          = arguments.fetch(:actor)
        @autoinvited    = arguments.fetch(:autoinvited)
        @workspace      = arguments.fetch(:workspace)
        @enforcer       = arguments.fetch(:enforcer)
        @autoinvitation = arguments.fetch(:autoinvitation)
        @tracker        = arguments.fetch(:tracker)
      end #initialize

      def call
        enforcer       .authorize(actor, :reject)
        autoinvitation .reject
        tracker.untrack_autoinvitation(workspace, autoinvited, autoinvitation)

        will_sync autoinvitation, tracker
      end #call

      private

      attr_reader :actor, :autoinvited, :workspace, :enforcer, :autoinvitation,
                  :tracker
    end # Context
  end # RejectAutoinvitationToWorkspace
end # Belinkr

