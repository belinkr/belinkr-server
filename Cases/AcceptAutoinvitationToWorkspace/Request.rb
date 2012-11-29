# encoding: utf-8
require_relative '../../Resources/Workspace/Autoinvitation/Member'
require_relative '../../Resources/Workspace/Autoinvitation/Enforcer'
require_relative '../../Resources/Workspace/Member'
require_relative '../../Resources/User/Member'
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
          actor:          actor,
          workspace:      workspace,
          autoinvitation: autoinvitation,
          autoinvited:    autoinvited,
          enforcer:       Workspace::Autoinvitation::Enforcer.new,
          tracker:        Workspace::Tracker.new
        }
      end #prepare

      private

      attr_reader :payload, :actor, :entity

      def autoinvitation
        @autoinvitation ||= Workspace::Autoinvitation.new(
          id:           payload.fetch('id')
          workspace_id: payload.fetch('workspace_id'),
          entity_id:    entity.id
        ).fetch
      end #autoinvitation

      def workspace
        @workspace ||= Workspace::Member.new(
          id:           payload.fetch('workspace_id'),
          user_id:      actor.id
          entity_id:    entity.id
        ).fetch
      end #workspace

      def autoinvited
        User::Member.new(id: autoinvitation.autoinvited_id).fetch
      end #autoinvited
    end # Request
  end # AcceptAutoinvitationToWorkspace
end # Belinkr

