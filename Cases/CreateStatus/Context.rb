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
      end #initialize

      def call
        enforcer.authorize(actor, :create_status)
        timelines.each { |timeline| timeline.add status } 

        will_sync status, *timelines
      end #call

      private

      attr_reader :enforcer, :actor, :status, :timelines
    end # Context
  end # CreateStatus
end # Belinkr

