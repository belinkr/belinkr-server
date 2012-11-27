# encoding: utf-8
require 'Tinto/Context'

module Belinkr
  module RejectInvitationToWorkspace
    class Context
      include Tinto::Context

      def initialize(arguments)
        @actor                      = arguments.fetch(:actor)
        @workspace                  = arguments.fetch(:workspace)
        @enforcer                   = arguments.fetch(:enforcer)
        @invitation                 = arguments.fetch(:invitation)
        @tracker                    = arguments.fetch(:tracker)
        @memberships_as_invited     = arguments.fetch(:memberships_as_invited)
      end #initialize

      def call
        enforcer                    .authorize(actor, :reject)
        invitation                  .reject
        tracker                     .delete(:invited, actor.id)
        memberships_as_invited      .delete(workspace)

        will_sync invitation, tracker, memberships_as_invited
      end #call

      private

      attr_reader :actor, :workspace, :enforcer, :invitation, :tracker, 
                  :memberships_as_invited
    end # Context
  end # RejectInvitationToWorkspace
end # Belinkr

