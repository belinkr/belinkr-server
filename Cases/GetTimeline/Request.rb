# encoding: utf-8
require_relative '../../Resources/Status/Scope'
require_relative '../../Resources/Status/Collection'

module Belinkr
  module GetTimeline
    class Request
      def initialize(arguments)
        @payload    = arguments.fetch(:payload)
        @actor      = arguments.fetch(:actor)
        @entity     = arguments.fetch(:entity)
        @resource   = arguments.fetch(:resource, nil)
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

