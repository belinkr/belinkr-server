# encoding: utf-8
require_relative '../../Resources/User/Member'
require_relative '../../Resources/Workspace/Member'
require_relative '../../Resources/Workspace/Enforcer'
require_relative '../../Services/Tracker'

module Belinkr
  module AssignAdministratorRoleInWorkspace
    class Request
      def initialize(arguments)
        @payload  = arguments.fetch(:payload)
        @actor    = arguments.fetch(:actor)
        @entity   = arguments.fetch(:entity)
      end #initialize

      def prepare
        {
          actor:        actor,
          target_user:  target_user,
          workspace:    workspace,
          enforcer:     enforcer,
          tracker:      tracker
        }
      end # prepare

      private
      
      attr_reader :payload, :actor, :entity

      def target_user
        @target_user ||= User::Member.new(id: payload.fetch('user_id')).fetch
      end #target_user

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
  end # AssignAdministratorRoleInWorkspace
end # Belinkr
