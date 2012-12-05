# encoding: utf-8
require 'Tinto/Exceptions'

module Belinkr
  module Follower
    class Enforcer
      include Tinto::Exceptions

      def initialize(followed)
        @followed = followed
      end #followed

      def authorize(actor, action)
        #raise NotAllowed if actor.id == followed.id
        return true
      end #authorize

      private

      attr_reader :followed
    end # Enforcer
  end # Follower
end # Belinkr

