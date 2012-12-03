# encoding: utf-8
require_relative '../../Resources/Workspace/Member'
require_relative '../../Resources/Workspace/Enforcer'

module Belinkr
  module EditWorkspace
    class Request
      def initialize(payload, actor, entity)
        @payload  = payload
        @actor    = actor
        @entity   = entity
      end #initialize

      def prepare
        {
          actor:              actor,
          enforcer:           enforcer,
          workspace:          workspace,
          workspace_changes:  payload
        }
      end #prepare

      private

      attr_accessor :payload, :actor, :entity

      def workspace
        @workspace ||= Workspace::Member.new(
          id:         payload.fetch('workspace_id'),
          entity_id:  entity.id
        ).fetch
      end #workspace

      def enforcer
        Workspace::Enforcer.new(workspace)
      end #enforcer
    end # Request
  end # EditWorkspace
end # Belinkr
