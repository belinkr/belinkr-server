# encoding: utf-8
require_relative './Enforcer'
require_relative '../../Services/Tracker'
require_relative '../../Services/Timeliner'

module Belinkr
  module Workspace
    class Scope
      RESOURCE_TIMELINES  = %w{ general files }
      MEMBER_TIMELINES    = %w{ workspaces files }

      def initialize(payload, status, entity)
        @payload    = payload
        @status     = status
        @entity     = entity
        @tracker    = Workspace::Tracker.new
        @timeliner  = Timeliner.new(status)
      end #initialize

      def resource
        @resource ||= Workspace::Member.new(
          id:         payload.fetch('workspace_id'),
          entity_id:  entity.id
        )
      end

      def enforcer
        Workspace::Enforcer.new(resource)
      end

      def timelines
        timeliner.resource_timelines_for(resource, RESOURCE_TIMELINES ) +
        timeliner.member_timelines_for(members, MEMBER_TIMELINES)
      end #timelines

      def members
        tracker.users_for(resource, :member)
      end #members

      private

      attr_reader :payload, :status, :entity, :tracker, :timeliner
    end # Scope
  end # Workspace
end # Belinkr

