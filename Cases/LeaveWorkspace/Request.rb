# encoding: utf-8
require_relative '../../Resources/Workspace/Member'
require_relative '../../Resources/Workspace/Enforcer'
require_relative '../../Services/Tracker'
  
module Belinkr
  module LeaveWorkspace
    class Request
      def initialize(payload, actor, entity)
        @payload  = payload
        @actor    = actor
        @entity   = entity
      end #initialize

      def prepare
        {
          actor:      actor,
          workspace:  workspace,
          enforcer:   enforcer,
          tracker:    tracker
        }
      end #prepare

      private

      attr_reader :payload, :actor, :entity

      def workspace
        @workspace ||= Workspace::Member.new(
          id:         payload.fetch('workspace_id'),
          entity_id:  entity.id
        ).fetch
      end #workspace

      def enforcer
        Workspace::Enforcer.new(workspace)
      end #enforcer

      def tracker
        Workspace::Tracker.new
      end #tracker
    end # Request
  end # LeaveWorkspace
end # Belinkr

