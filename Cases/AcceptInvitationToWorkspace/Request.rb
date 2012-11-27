# encoding: utf-8
require 'set'
require_relative '../../Resources/Workspace/Invitation/Member'
require_relative '../../Resources/Workspace/Invitation/Enforcer'
require_relative '../../Resources/Workspace/Membership/Collection'
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
          actor:                        actor,
          enforcer:                     enforcer,
          workspace:                    workspace,
          invitation:                   invitation,
          tracker:                      tracker,
          memberships_as_invited:       memberships_as_invited,
          memberships_as_collaborator:  memberships_as_collaborator
        }
      end #prepare

      private

      attr_reader :payload, :actor, :entity

      def invitation
        Workspace::Invitation::Member.new(
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

      def tracker
        Workspace::Tracker.new(entity.id, workspace.id)
      end #tracker

      def enforcer
        Workspace::Invitation::Enforcer.new(
          collaborators:  Set.new,
          administrators: Set.new
        )
      end #enforcer

      def memberships_as_invited
        Workspace::Membership::Collection.new(
          kind: 'invited',
          user_id: actor.id,
          entity_id: entity.id
        )
      end

      def memberships_as_collaborator
        Workspace::Membership::Collection.new(
          kind: 'collaborator',
          user_id: actor.id,
          entity_id: entity.id
        )
      end
    end # Request
  end # AcceptInvitationToWorkspace
end # Belinkr

