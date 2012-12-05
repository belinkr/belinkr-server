# encoding: utf-8
require 'Tinto/Exceptions'

module Belinkr
  module Scrapbook
    class Enforcer
      include Tinto::Exceptions

      def initialize(scrapbook)
        @scrapbook = scrapbook
      end #scrapbook

      def authorize(actor, action)
        raise unless actor.id == scrapbook.user_id
        return true
      end #authorize

      private

      attr_reader :scrapbook
    end # Enforcer
  end # Scrapbook
end # Belinkr

