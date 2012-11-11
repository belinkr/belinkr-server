# encoding: utf-8
require_relative '../../Tinto/Context'

module Belinkr
  module RejectAutoinvitationToWorkspace
    class Context
      include Tinto::Context

      def initialize(arguments)
        @actor                      = arguments.fetch(:actor)
        @autoinvited                = arguments.fetch(:autoinvited)
        @workspace                  = arguments.fetch(:workspace)
        @enforcer                   = arguments.fetch(:enforcer)
        @autoinvitation             = arguments.fetch(:autoinvitation)
        @tracker                    = arguments.fetch(:tracker)
        @memberships_as_autoinvited = arguments
                                        .fetch(:memberships_as_autoinvited)
      end #initialize

      def call
        enforcer                    .authorize(actor, :reject)
        autoinvitation              .reject
        tracker                     .delete(:autoinvited, autoinvited.id)
        memberships_as_autoinvited  .delete(workspace)

        will_sync autoinvitation, tracker, memberships_as_autoinvited
      end #call

      private

      attr_reader :actor, :autoinvited, :workspace, :enforcer, :autoinvitation,
                  :tracker, :memberships_as_autoinvited
    end # Context
  end # RejectAutoinvitationToWorkspace
end # Belinkr

