# encoding: utf-8
require 'Tinto/Context'

module Belinkr
  module ResetPassword
    class Context
      include Tinto::Context

      def initialize(arguments)
        @actor        = arguments.fetch(:actor)
        @user_changes = arguments.fetch(:user_changes)
        @reset        = arguments.fetch(:reset)
        @resets       = arguments.fetch(:resets)
      end #initialize

      def call
        actor.update(user_changes)
        reset.delete
        resets.delete reset

        will_sync actor, reset, resets
      end #call

      private

      attr_reader :actor, :user_changes, :reset, :resets
    end # Context
  end # ResetPassword
end # Belinkr

