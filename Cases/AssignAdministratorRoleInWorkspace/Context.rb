# encoding: utf-8
require_relative '../../Tinto/Context'

module Belinkr
  module AssignAdministratorRoleInWorkspace
    class Context
      include Tinto::Context

      def initialize(arguments)
        @actor                      = arguments.fetch(:actor)
        @target_user                = arguments.fetch(:target_user)
        @workspace                  = arguments.fetch(:workspace)
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
        administrator_memberships.add(workspace)

        tracker.delete('collaborator', target_user.id)
        tracker.add('administrator', target_user.id)

        will_sync collaborator_memberships, administrator_memberships, tracker
      end #call

      private

      attr_reader :actor, :target_user, :workspace, :enforcer, :tracker,
                  :admnistrator_memberships, :collaborator_memberships
    end # Context
  end # AssignAdministratorRoleInWorkspace
end # Belinkr

