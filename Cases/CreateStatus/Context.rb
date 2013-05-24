# encoding: utf-8
require 'Tinto/Context'

module Belinkr
  module CreateStatus
    class Context
      include Tinto::Context

      def initialize(arguments)
        @enforcer           = arguments.fetch(:enforcer)
        @actor              = arguments.fetch(:actor)
        @status             = arguments.fetch(:status)
        @timelines          = arguments.fetch(:timelines)
        @scope_resource     = arguments.fetch(:scope_resource)
      end #initialize

      def call
        enforcer.authorize(actor, :create_status)
        timelines.each { |timeline| timeline.add status }

        #FIXME use some duck type instead of respond_to?
        if scope_resource.respond_to? :increment_status_counter
          scope_resource.fetch.increment_status_counter
        end

        will_sync status, *timelines, scope_resource
      end #call

      private

      attr_reader :enforcer, :actor, :status, :timelines, :scope_resource
    end # Context
  end # CreateStatus
end # Belinkr

