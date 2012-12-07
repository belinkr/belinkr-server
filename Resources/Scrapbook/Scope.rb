# encoding: utf-8
require_relative './Enforcer'
require_relative '../../Services/Timeliner'

module Belinkr
  module Scrapbook
    class Scope
      RESOURCE_TIMELINES  = %w{ general files }

      def initialize(payload, status, actor)
        @payload    = payload
        @status     = status
        @actor      = actor
        @timeliner  = Timeliner.new(status)
      end #initialize

      def resource
        actor
      end

      def enforcer
        Scrapbook::Enforcer.new(resource)
      end

      def timelines
        timeliner.resource_timelines_for(resource, RESOURCE_TIMELINES)
      end #timelines

      private

      attr_reader :payload, :status, :entity, :actor, :timeliner
    end # Scope
  end # Scrapbook
end # Belinkr

