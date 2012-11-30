# encoding: utf-8
require_relative '../../Resources/Workspace/Invitation/Member'
require_relative '../../Resources/Workspace/Invitation/Collection'
require_relative '../../Resources/Workspace/Invitation/Enforcer'
require_relative '../../Resources/Workspace/Member'
require_relative '../../Services/Tracker'

module Belinkr
  module InviteUserToWorkspace
    class Request
      def initialize(payload, actor, entity)
        @payload  = payload
        @actor    = actor
        @entity   = entity
      end # initialize

      def prepare
        {
          actor:        actor,
          workspace:    workspace,
          invited:      invited,
          invitation:   invitation,
          invitations:  invitations,
          enforcer:     enforcer,
          tracker:      tracker
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

      def invited
        @invited ||= User::Member.new(id: payload.fetch('invited_id')).fetch
      end #invited

      def invitation
        @invitation ||= Workspace::Invitation::Member.new(
          inviter_id:   actor.id,
          invited_id:   payload.fetch('invited_id'),
          workspace_id: payload.fetch('workspace_id'),
          entity_id:    entity.id
        )
      end #invitation

      def invitations
        @invitations ||= Workspace::Invitation::Collection.new(
          workspace_id: payload.fetch('workspace_id'),
          entity_id:    entity.id
        )
      end #invitations

      def enforcer
        Workspace::Invitation::Enforcer.new(workspace, invitation, tracker)
      end #enforcer

      def tracker
        @tracker ||= Workspace::Tracker.new
      end #tracker
    end # Request
  end # InviteUserToWorkspace
end # Belinkr

