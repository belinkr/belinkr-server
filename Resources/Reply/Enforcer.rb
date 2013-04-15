# encoding: utf-8
require 'Tinto/Exceptions'

module Belinkr
  module Reply
    class Enforcer
      include Tinto::Exceptions

      def authorize(user, action)
        send :"#{action}_by?", user
      end

      def initialize(status, reply)
        @status = status
        @reply  = reply
      end

      def create_by?(user)
        true
      end

      def read_by?(user)
        true
      end

      def update_by?(user)
        raise NotAllowed unless user.id == @reply.author_id
        true
      end

      def delete_by?(user)
        raise NotAllowed unless user.id == @reply.author.id
        true
      end

      alias_method :undelete_by?,   :delete_by?
      alias_method :destroy_by?,    :delete_by?

      private

    end # Enforcer
  end # Reply
end # Belinkr
