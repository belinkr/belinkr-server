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
        raise_if_deleted_resource

        return true       if get_status_or_timeline?(action)
        raise NotAllowed  unless user.id == actor.id
        return true
      end #authorize

      private

      attr_reader :user

      def raise_if_deleted_resource
        raise NotFound if user.deleted_at
      end #raise_if_deleted_resource

      def get_status_or_timeline?(action)
        action =~ /get/
      end #get_status_or_timeline?
    end # Enforcer
  end # User
end # Belinkr

