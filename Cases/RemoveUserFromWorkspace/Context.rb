# encoding: utf-8
require 'Tinto/Context'

module Belinkr
  module RemoveWorkspace
    class Context
      include Tinto::Context

      def initialize(arguments)
        @actor                      = arguments.fetch(:actor)
        @workspace                  = arguments.fetch(:workspace)
        @target_user                = arguments.fetch(:target_user)
        @enforcer                   = arguments.fetch(:enforcer)
        @tracker                    = arguments.fetch(:tracker)
        @administrator_memberships  = arguments
                                        .fetch(:administrator_memberships)
        @collaborator_memberships   = arguments
                                        .fetch(:collaborator_memberships)
      end #initialize

      def call
        enforcer.authorize(actor, :remove)
        collaborator_memberships.delete(workspace)
        administrator_memberships.delete(workspace)

        tracker.delete('administrator', target_user.id)
        tracker.delete('collaborator', target_user.id)

        will_sync collaborator_memberships, administrator_memberships, tracker
      end #call

      private

      attr_reader :actor, :workspace, :target_user, :enforcer, :tracker,
                  :administrator_memberships, :collaborator_memberships
    end # Context
  end # RemoveWorkspace
end # Belinkr

