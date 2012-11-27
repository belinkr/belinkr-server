# encoding: utf-8
require 'Tinto/Exceptions'

module Belinkr
  module User
    class Enforcer
      include Tinto::Exceptions

      def initialize(user)
        @user = user
      end #user

      def authorize(actor, action)
        raise NotAllowed unless user.id == actor.id
        return true
      end #authorize

      private

      attr_reader :user
    end # Enforcer
  end # User
end # Belinkr

