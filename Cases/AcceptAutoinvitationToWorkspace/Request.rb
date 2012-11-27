# encoding: utf-8
require_relative '../../Resources/Workspace/Autoinvitation/Member'
require_relative '../../Resources/Workspace/Autoinvitation/Enforcer'
require_relative '../../Resources/Workspace/Membership/Collection'
require_relative '../../Resources/Workspace/Member'
require_relative '../../Services/Tracker'

module Belinkr
  module AcceptAutoinvitationToWorkspace
    class Request
      def initialize(payload, actor, entity)
        @payload  = payload
        @actor    = actor
        @entity   = entity
      end #initialize

      def prepare
        {
          actor:                        current_user,
          enforcer:                     enforcer,
          workspace:                    workspace,
          autoinvitation:               autoinvitation,
          tracker:                      tracker,
          memberships_as_autoinvited:   memberships_as_autoinvited,
          memberships_as_collaborator:  memberships_as_collaborator
        }
      end #prepare

      private

      attr_reader :payload, :actor, :entity

      def autoinvitation
        Workspace::Autoinvitation.new(
          id:           payload.fetch('id')
          workspace_id: payload.fetch('workspace_id'),
          entity_id:    entity.id
        )
      end #autoinvitation

      def workspace
        Workspace::Member.new(
          id:           payload.fetch('workspace_id'),
          user_id:      actor.id
          entity_id:    entity.id
        )
      end #workspace

      def tracker
        Workspace::Tracker.new(entity_id, workspace_id)
      end #tracker

      def enforcer
        Workspace::Autoinvitation::Enforcer.new
      end #enforcer

      def memberships_as_autoinvited
        Workspace::Membership::Collection.new(
          kind: 'autoinvited'
          user_id: user.id
          entity_id: entity.id
        )
      end
    end # Request
  end # AcceptAutoinvitationToWorkspace
end # Belinkr

