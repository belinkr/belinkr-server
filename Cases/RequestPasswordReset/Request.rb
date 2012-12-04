# encoding: utf-8
require_relative '../../Services/Locator'
require_relative '../../Resources/User/Member'
require_relative '../../Resources/Reset/Member'
require_relative '../../Resources/Reset/Collection'
require_relative '../../Resources/Message/Member'

module Belinkr
  module RequestPasswordReset
    class Request
      def initialize(payload)
        @payload = payload
      end #initialize

      def prepare
        {
          actor:    user,
          reset:    reset,
          resets:   resets,
          message:  message
        }
      end #prepare

      private

      attr_reader :payload

      def reset
        Reset::Member.new
      end #reset

      def resets
        Reset::Collection.new
      end #resets

      def user
        return @user if @user
        user_token  = payload.fetch('email')
        user_id     = User::Locator.new.id_for(user_token)
        @user       = User::Member.new(id: user_id).fetch
      end #user

      def message
        Message::Member.new
      end #message
    end # Request
  end # RequestPasswordReset
end # Belinkr

