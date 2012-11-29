# encoding: utf-8
require 'Tinto/Context'

module Belinkr
  module CreateWorkspace
    class Context
      include Tinto::Context

      def initialize(arguments)
        @actor      = arguments.fetch(:actor)
        @workspace  = arguments.fetch(:workspace)
        @workspaces = arguments.fetch(:workspaces)
        @entity     = arguments.fetch(:entity)
        @tracker    = arguments.fetch(:tracker)
      end

      def call
        workspace   .link_to(entity)
        workspaces  .add(workspace)
        tracker     .register(workspace, actor, :administrator)

        will_sync workspace, workspaces, tracker
      end #call

      private

      attr_reader :actor, :workspace, :workspaces, :entity, :tracker
    end # Context
  end # CreateWorkspace
end # Belinkr

