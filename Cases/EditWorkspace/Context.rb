# encoding: utf-8
require 'Tinto/Context'

module Belinkr
  module EditWorkspace
    class Context
      include Tinto::Context

      def initialize(arguments)
        @enforcer           = arguments.fetch(:enforcer)
        @actor              = arguments.fetch(:actor)
        @workspace          = arguments.fetch(:workspace)
        @workspace_changes  = arguments.fetch(:workspace_changes)
      end #initialize

      def call
        enforcer.authorize(actor, :update)
        workspace.update(workspace_changes)

        will_sync workspace
      end # call

      private

      attr_reader :enforcer, :actor, :workspace, :workspace_changes
    end # Context
  end # EditWorkspace
end # Belinkr

