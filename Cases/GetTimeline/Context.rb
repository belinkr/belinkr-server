# encoding: utf-8
require 'Tinto/Context'

module Belinkr
  module GetTimeline
    class Context
      include Tinto::Context

      def initialize(arguments)
        @enforcer           = arguments.fetch(:enforcer)
        @actor              = arguments.fetch(:actor)
        @timeline           = arguments.fetch(:timeline)
      end #initialize

      def call
        enforcer.authorize(actor, :get_timeline)
      end #call

      private

      attr_reader :enforcer, :actor, :timeline
    end # Context
  end # GetTimeline
end # Belinkr

