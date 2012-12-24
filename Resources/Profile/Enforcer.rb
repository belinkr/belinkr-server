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
        return true
      end #authorize

      private

      attr_reader :profile
    end # Enforcer
  end # Profile
end # Belinkr

