# encoding: utf-8
require_relative '../../Resources/Workspace/Member'
require_relative '../../Resources/Workspace/Collection'
require_relative '../../Resources/Workspace/Enforcer'
require_relative '../../Services/Tracker'
  
module Belinkr
  module DeleteWorkspace
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
          workspaces: workspaces,
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

      def workspaces
        @workspaces ||= Workspace::Collection.new(entity_id: entity.id)
      end #workspaces

      def enforcer
        Workspace::Enforcer.new(workspace)
      end #enforcer

      def tracker
        Workspace::Tracker.new
      end #tracker
    end # Request
  end # DeleteWorkspace
end # Belinkr

