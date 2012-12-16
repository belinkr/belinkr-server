# encoding: utf-8
require_relative '../../Resources/Workspace/Invitation/Member'
require_relative '../../Resources/Workspace/Invitation/Enforcer'
require_relative '../../Resources/Workspace/Member'
require_relative '../../Services/Tracker'

module Belinkr
  module AcceptInvitationToWorkspace
    class Request
      def initialize(arguments)
        @payload  = arguments.fetch(:payload)
        @actor    = arguments.fetch(:actor)
        @entity   = arguments.fetch(:entity)
      end # initialize

      def prepare
        {
          actor:      actor,
          workspace:  workspace,
          invitation: invitation,
          enforcer:   enforcer,
          tracker:    tracker
        }
      end #prepare

      private

      attr_reader :payload, :actor, :entity

      def workspace
        @workspace ||= Workspace::Member.new(
          id:           payload.fetch('workspace_id'),
          entity_id:    entity.id
        ).fetch
      end #workspace

      def invitation
        @invitation ||= Workspace::Invitation::Member.new(
          id:           payload.fetch('invitation_id'),
          workspace_id: payload.fetch('workspace_id'),
          entity_id:    entity.id
        ).fetch
      end #invitation

      def enforcer
        Workspace::Invitation::Enforcer.new(workspace, invitation, tracker)
      end #enforcer

      def tracker
        @tracker ||= Workspace::Tracker.new
      end #tracker
    end # Request
  end # AcceptInvitationToWorkspace
end # Belinkr

