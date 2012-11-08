# encoding: utf-8
require_relative '../../Tinto/Context'

module Belinkr
  module CreateWorkspace
    class Context
      include Tinto::Context

      def initialize(arguments)
        @actor                      = arguments.fetch(:actor)
        @workspace                  = arguments.fetch(:workspace)
        @workspaces                 = arguments.fetch(:workspaces)
        @entity                     = arguments.fetch(:entity)
        @tracker                    = arguments.fetch(:tracker)
        @administrators             = arguments.fetch(:administrators)
        @administrator_memberships  = arguments
                                        .fetch(:administrator_memberships)
      end

      def call
        workspace                   .link_to(entity)
        workspaces                  .add(workspace)
        administrators              .add(actor)
        administrator_memberships   .add(workspace)
        tracker                     .add('administrator', actor.id)

        will_sync workspace, workspaces, administrators, 
                  administrator_memberships, tracker
      end #call

      private

      attr_reader :actor, :workspace, :workspaces, :administrators, 
                  :administrator_memberships, :tracker, :entity
    end # Context
  end # CreateWorkspace
end # Belinkr

