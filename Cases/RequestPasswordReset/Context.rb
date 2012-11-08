# encoding: utf-8
require_relative '../../Tinto/Context'

module Belinkr
  module RequestPasswordReset
    class Context
      include Tinto::Context

      def initialize(arguments)
        @actor    = arguments.fetch(:actor)
        @reset    = arguments.fetch(:reset)
        @resets   = arguments.fetch(:resets)
        @message  = arguments.fetch(:message)
      end

      def call
        reset.link_to(actor)
        resets.add(reset)
        message.prepare(:reset_for, actor, reset)

        will_sync reset, resets, message
      end #call

      private

      attr_reader :actor, :reset, :resets, :message
    end # Context
  end # RequestPasswordReset
end # Belinkr

