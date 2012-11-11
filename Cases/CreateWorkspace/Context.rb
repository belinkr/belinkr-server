# encoding: utf-8
require_relative '../../Tinto/Context'

module Belinkr
  module CreateWorkspace
    class Context
      include Tinto::Context

      def initialize(arguments)
        @actor                        = arguments.fetch(:actor)
        @workspace                    = arguments.fetch(:workspace)
        @workspaces                   = arguments.fetch(:workspaces)
        @entity                       = arguments.fetch(:entity)
        @tracker                      = arguments.fetch(:tracker)
        @administrators               = arguments.fetch(:administrators)
        @memberships_as_administrator = arguments
                                        .fetch(:memberships_as_administrator)
      end

      def call
        workspace                     .link_to(entity)
        workspaces                    .add(workspace)
        administrators                .add(actor)
        memberships_as_administrator  .add(workspace)
        tracker                       .add(:administrator, actor.id)

        will_sync workspace, workspaces, administrators, 
                  memberships_as_administrator, tracker
      end #call

      private

      attr_reader :actor, :workspace, :workspaces, :administrators, 
                  :memberships_as_administrator, :tracker, :entity
    end # Context
  end # CreateWorkspace
end # Belinkr

