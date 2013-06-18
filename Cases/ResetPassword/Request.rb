# encoding: utf-8
require_relative '../../Resources/User/Member'
require_relative '../../Resources/Reset/Member'
require_relative '../../Resources/Reset/Collection'

module Belinkr
  module ResetPassword
    class Request
      def initialize(arguments)
        @payload = arguments.fetch(:payload)
      end #initialize

      def prepare
        {
          actor:        user,
          user_changes: {"password"=>payload.fetch('password')},
          reset:        reset,
          resets:       resets
        }
      end #prepare

      private

      attr_reader :payload

      def reset
        @reset ||= Reset::Member.new(id: payload.fetch('reset_id')).fetch
      end #reset

      def resets
        Reset::Collection.new
      end #resets

      def user
        @user ||= User::Member.new(id: reset.user_id).fetch
      end #user
    end # Request
  end # ResetPassword
end # Belinkr

