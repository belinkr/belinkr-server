# encoding: utf-8
require 'Tinto/Exceptions'

module Belinkr
  module Reply
    class Enforcer
      include Tinto::Exceptions

      def self.authorize(user, action, status, reply)
        new(status, reply).send :"#{action}_by?", user
      end

      def initialize(status, reply)
        @status = status
        @reply  = reply
      end

      def create_by?(user)
      end

      def read_by?(user)
      end

      def update_by?(user)
        raise NotAllowed unless user.id == @reply.user_id
      end

      def delete_by?(user)
        raise NotAllowed unless user.id == @reply.user_id
      end

      alias_method :undelete_by?,   :delete_by?
      alias_method :destroy_by?,    :delete_by?

      private

    end # Enforcer
  end # Reply
end # Belinkr
