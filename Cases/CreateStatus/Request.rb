# encoding: utf-8
require_relative '../../Resources/Status/Member'
require_relative '../../Resources/Status/Scope'
require_relative '../../Services/Timeliner'

module Belinkr
  module CreateStatus
    class Request
      def initialize(payload, actor, entity)
        @payload    = payload
        @actor      = actor
        @entity     = entity
      end #initialize

      def prepare
        {
          enforcer:   scope.enforcer,
          actor:      actor,
          status:     status,
          scope:      scope.resource,
          timelines:  timelines
        }
      end #prepare

      private

      attr_reader :payload, :actor, :entity

      def status
        Status::Member.new(payload.merge jail)
      end #status

      def jail
        { author: actor, scope: scope.resource }
      end #jail

      def scope
        Status::Scope.new(payload, actor, entity)
      end #scope

      def timelines
        @timelines ||= Timeliner.new(status).timelines_for(scope)
      end #timelines
    end # Request
  end # CreateStatus
end # Belinkr

