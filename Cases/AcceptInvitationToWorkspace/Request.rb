# encoding: utf-8
require_relative '../../Resources/Workspace/Invitation/Member'
require_relative '../../Resources/Workspace/Invitation/Enforcer'
require_relative '../../Resources/Workspace/Member'
require_relative '../../Services/Tracker'

module Belinkr
  module AcceptInvitationToWorkspace
    class Request
      def initialize(payload, actor, entity)
        @payload  = payload
        @actor    = actor
        @entity   = entity
      end # initialize

      def prepare
        {
          actor:      actor,
          workspace:  workspace,
          invitation: invitation,
          enforcer:   Workspace::Invitation::Enforcer.new,
          tracker:    Workspace::Tracker.new
        }
      end #prepare

      private

      attr_reader :payload, :actor, :entity

      def invitation
        @invitation ||= Workspace::Invitation::Member.new(
          id:           payload.fetch('id'),
          workspace_id: payload.fetch('workspace_id'),
          entity_id:    entity.id
        ).fetch
      end #invitation

      def workspace
        @workspace ||= Workspace::Member.new(
          id:           payload.fetch('workspace_id'),
          user_id:      actor.id,
          entity_id:    entity.id
        ).fetch
      end #workspace
    end # Request
  end # AcceptInvitationToWorkspace
end # Belinkr

