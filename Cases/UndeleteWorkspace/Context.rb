# encoding: utf-8
require 'Tinto/Context'

module Belinkr
  module UndeleteWorkspace
    class Context
      include Tinto::Context

      def initialize(arguments)
        @enforcer   = arguments.fetch(:enforcer)
        @actor      = arguments.fetch(:actor)
        @workspace  = arguments.fetch(:workspace)
        @workspaces = arguments.fetch(:workspaces)
        @tracker    = arguments.fetch(:tracker)
      end # initialize

      def call
        enforcer.authorize(actor, :undelete)
        workspaces.add(workspace)
        tracker.relink_to_all_users(workspace)

        will_sync workspace, workspaces, tracker
      end # call

      private

      attr_reader :enforcer, :actor, :workspace, :workspaces, :tracker
    end # Context
  end # UndeleteWorkspace
end # Belinkr

