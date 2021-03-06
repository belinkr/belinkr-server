# encoding: utf-8
require 'Tinto/Context'
require 'Tinto/Exceptions'

module Belinkr
  module CreateReply
    class Context
      include Tinto::Context

      def initialize(arguments)
        @enforcer = arguments.fetch(:enforcer)
        @actor    = arguments.fetch(:actor)
        @status   = arguments.fetch(:status)
        @reply    = arguments.fetch(:reply)
      end

      def call
        enforcer.authorize(actor, :create)
        reply.status_id = status.id

        status.replies  << reply
        will_sync status

      end

      private

      attr_reader :enforcer, :actor, :status, :reply
    end
  end
end
