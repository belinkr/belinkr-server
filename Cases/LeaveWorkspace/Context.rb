# encoding: utf-8
require_relative '../../Tinto/Context'

module Belinkr
  module LeaveWorkspace
    class Context
      include Tinto::Context

      def initialize(arguments)
        @actor                      = arguments.fetch(:actor)
        @workspace                  = arguments.fetch(:workspace)
        @enforcer                   = arguments.fetch(:enforcer)
        @tracker                    = arguments.fetch(:tracker)
        @administrator_memberships  = arguments
                                        .fetch(:administrator_memberships)
        @collaborator_memberships   = arguments
                                        .fetch(:collaborator_memberships)
      end #initialize

      def call
        enforcer.authorize(actor, :leave)
        collaborator_memberships.delete(workspace)
        administrator_memberships.delete(workspace)

        tracker.delete('administrator', actor.id)
        tracker.delete('collaborator', actor.id)

        will_sync collaborator_memberships, administrator_memberships, tracker
      end #call

      private
      
      attr_reader :actor, :workspace, :enforcer, :administrator_memberships,
                  :collaborator_memberships
    end # Context
  end # LeaveWorkspace
end # Belinkr

