# encoding: utf-8
require_relative '../../Resources/Status/Scope'
require_relative '../../Resources/Status/Scope'

module Belinkr
  module GetTimeline
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
          timeline:   timeline
        }
      end #prepare

      private

      attr_reader :payload, :actor, :entity

      def timeline
        @timeline ||= Status::Collection.new(
          kind:   payload.fetch('kind', 'general'),
          scope:  resource
        ).page(payload.fetch('page', 0))
      end #timeline

      def resource
        @resource ||= scope.resource
      end #resource

      def scope
        Status::Scope.new(payload, actor, entity)
      end #scope
    end # Request
  end # DeleteStatus
end # Belinkr

