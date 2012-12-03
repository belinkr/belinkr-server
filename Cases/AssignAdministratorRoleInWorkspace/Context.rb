# encoding: utf-8
require 'Tinto/Context'

module Belinkr
  module AssignAdministratorRoleInWorkspace
    class Context
      include Tinto::Context

      def initialize(arguments)
        @actor        = arguments.fetch(:actor)
        @target_user  = arguments.fetch(:target_user)
        @workspace    = arguments.fetch(:workspace)
        @enforcer     = arguments.fetch(:enforcer)
        @tracker      = arguments.fetch(:tracker)
      end #initialize

      def call
        enforcer.authorize(actor, :assign_role)
        tracker.track_administrator(workspace, target_user)

        will_sync tracker
      end #call

      private

      attr_reader :actor, :target_user, :workspace, :enforcer, :tracker
    end # Context
  end # AssignAdministratorRoleInWorkspace
end # Belinkr

