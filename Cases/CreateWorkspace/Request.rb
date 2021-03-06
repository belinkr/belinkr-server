# encoding: utf-8
require_relative '../../Resources/Workspace/Collection'
require_relative '../../Resources/Workspace/Member'
require_relative '../../Services/Tracker'

module Belinkr
  module CreateWorkspace
    class Request
      def initialize(arguments)
        @payload  = arguments.fetch(:payload)
        @actor    = arguments.fetch(:actor)
        @entity   = arguments.fetch(:entity)
      end #initialize

      def prepare
        {
          actor:      actor,
          workspace:  workspace,
          workspaces: workspaces,
          entity:     entity,
          tracker:    tracker
        }
      end #prepare

      private

      attr_reader :payload, :actor, :entity

      def workspace
        @workspace ||= Workspace::Member.new(payload.merge scope)
      end #workspace

      def workspaces
        @workspaces ||= Workspace::Collection.new(entity_id: entity.id)
      end #workspaces

      def tracker
        @tracker ||= Workspace::Tracker.new
      end #tracker

      def scope
        { entity_id: entity.id }
      end # scope
    end # Request
  end # CreateWorkspace
end # Belinkr

