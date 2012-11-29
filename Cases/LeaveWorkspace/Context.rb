# encoding: utf-8
require 'Tinto/Context'

module Belinkr
  module LeaveWorkspace
    class Context
      include Tinto::Context

      def initialize(arguments)
        @actor      = arguments.fetch(:actor)
        @workspace  = arguments.fetch(:workspace)
        @enforcer   = arguments.fetch(:enforcer)
        @tracker    = arguments.fetch(:tracker)
      end #initialize

      def call
        enforcer.authorize(actor, :leave)
        tracker.remove(workspace, actor)

        will_sync tracker
      end #call

      private
      
      attr_reader :actor, :workspace, :enforcer, :tracker
    end # Context
  end # LeaveWorkspace
end # Belinkr

