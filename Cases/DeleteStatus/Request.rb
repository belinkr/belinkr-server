# encoding: utf-8
require_relative '../../Resources/Status/Member'
require_relative '../../Resources/Status/Scope'
require_relative '../../Services/Timeliner'

module Belinkr
  module DeleteStatus
    class Request
      def initialize(payload, actor, entity, resource=nil)
        @payload    = payload
        @actor      = actor
        @entity     = entity
        @resource   = resource
      end #initialize

      def prepare
        {
          enforcer:   scope.enforcer,
          actor:      actor,
          status:     status,
          timelines:  timelines
        }
      end #prepare

      private

      attr_reader :payload, :actor, :entity

      def status
        @status ||= Status::Member.new(
          id:     payload.fetch('status_id'),
          scope:  resource
        ).fetch
      end #status

      def resource
        @resource ||= scope.resource
      end #resource

      def scope
        Status::Scope.new(payload, actor, entity)
      end #scope

      def timelines
        @timelines ||= Timeliner.new(status).timelines_for(scope)
      end #timelines
    end # Request
  end # DeleteStatus
end # Belinkr

