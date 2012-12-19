# encoding: utf-8
require 'Tinto/Exceptions'

module Belinkr
  module Profile
    class Enforcer
      include Tinto::Exceptions

      def initialize(profile)
        @profile = profile
      end #profile

      def authorize(actor, action)
        return true if action =~ /collection/
        raise_if_deleted_resource
        return true
      end #authorize

      private

      attr_reader :profile

      def raise_if_deleted_resource
        raise NotFound if profile.deleted_at
      end #raise_if_deleted_resource
    end # Enforcer
  end # Profile
end # Belinkr

