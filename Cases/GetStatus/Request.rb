# encoding: utf-8
require_relative '../../Resources/Status/Member'
require_relative '../../Resources/Status/Scope'

module Belinkr
  module GetStatus
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
          status:     status
        }
      end #prepare

      private

      attr_reader :payload, :actor, :entity

      def status
        @status ||= Status::Member.new(
          id:     payload.fetch('status_id'),
          scope:  resource
        ).fetch
        raise Tinto::Exceptions::NotFound if @status.deleted_at

        @status
      end #status

      def resource
        @resource ||= scope.resource
      end #resource

      def scope
        Status::Scope.new(payload, actor, entity)
      end #scope
    end # Request
  end # GetStatus
end # Belinkr

