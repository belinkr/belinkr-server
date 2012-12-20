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
        return true if action =~ /collection/

        raise NotFound    if user.deleted? || !has_profile_in_current_entity?
        raise NotAllowed  if action =~ /update/ && user.id != actor.id
        return true
      end #authorize

      private

      attr_reader :user

      def has_profile_in_current_entity?
        true #!!user.profile
      end #has_profile_in_current_entity?
    end # Enforcer
  end # User
end # Belinkr

