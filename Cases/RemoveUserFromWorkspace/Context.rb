# encoding: utf-8
require 'Tinto/Context'

module Belinkr
  module RemoveUserFromWorkspace
    class Context
      include Tinto::Context

      def initialize(arguments)
        @actor                      = arguments.fetch(:actor)
        @workspace                  = arguments.fetch(:workspace)
        @target_user                = arguments.fetch(:target_user)
        @enforcer                   = arguments.fetch(:enforcer)
        @tracker                    = arguments.fetch(:tracker)
      end #initialize

      def call
        enforcer.authorize(actor, :remove)
        tracker.remove(workspace, target_user)

        will_sync tracker
      end #call

      private

      attr_reader :actor, :workspace, :target_user, :enforcer, :tracker
    end # Context
  end # RemoveUserFromWorkspace
end # Belinkr

