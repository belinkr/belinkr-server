# encoding: utf-8
require 'Tinto/Context'

module Belinkr
  module GetStatus
    class Context
      include Tinto::Context

      def initialize(arguments)
        @enforcer           = arguments.fetch(:enforcer)
        @actor              = arguments.fetch(:actor)
        @status             = arguments.fetch(:status)
      end #initialize

      def call
        enforcer.authorize(actor, :get_status)
      end #call

      private

      attr_reader :enforcer, :actor, :status
    end # Context
  end # GetStatus
end # Belinkr

