# encoding: utf-8
require_relative '../../Resources/Workspace/Autoinvitation/Member'
require_relative '../../Resources/Workspace/Autoinvitation/Collection'
require_relative '../../Resources/Workspace/Autoinvitation/Enforcer'
require_relative '../../Resources/Workspace/Member'
require_relative '../../Resources/User/Member'
require_relative '../../Services/Tracker'

module Belinkr
  module AutoinviteToWorkspace
    class Request
      def initialize(payload, actor, entity)
        @payload  = payload
        @actor    = actor
        @entity   = entity
      end #initialize

      def prepare
        {
          actor:            actor,
          workspace:        workspace,
          autoinvitation:   autoinvitation,
          autoinvitations:  autoinvitations,
          enforcer:         enforcer,
          tracker:          tracker
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

      def autoinvitation
        @autoinvitation ||= Workspace::Autoinvitation::Member.new(
          payload.merge scope
        )
      end #autoinvitation

      def autoinvitations
        @autoinvitations ||= Workspace::Autoinvitation::Collection.new(
          workspace_id: payload.fetch('workspace_id'),
          entity_id:    entity.id
        )
      end #autoinvitations

      def enforcer
        Workspace::Autoinvitation::Enforcer
          .new(workspace, autoinvitation, tracker)
      end #enforcer

      def tracker
        @tracker ||= Workspace::Tracker.new
      end #tracker

      def scope
        { entity_id: entity.id }
      end #scope
    end # Request
  end # AutoinviteToWorkspace
end # Belinkr

