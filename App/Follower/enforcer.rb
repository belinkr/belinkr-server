# encoding: utf-8
require_relative "../../tinto/exceptions"

module Belinkr
  module Follower
    class Enforcer
      include Tinto::Exceptions

      def self.authorize(user, action, followed)
        new(followed).send :"#{action}_by?", user
      end

      def initialize(followed)
        @followed = followed
      end

      def create_by?(user)
        raise NotAllowed      unless user.id
        raise NotAllowed      unless user.entity_id == @followed.entity_id
        raise InvalidResource if user.id == @followed.id
      end

      alias_method :read_by?,       :create_by?    
      alias_method :collection_by?, :create_by?
      alias_method :delete_by?,     :create_by?
      alias_method :undelete_by?,   :create_by?
      alias_method :destroy_by?,    :create_by?
    end # Enforcer
  end # Follower
end # Belinkr
