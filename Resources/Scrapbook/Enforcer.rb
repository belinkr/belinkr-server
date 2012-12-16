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
        raise_if_deleted_resource
        raise unless actor.id == scrapbook.user_id
        return true
      end #authorize

      private

      attr_reader :scrapbook

      def raise_if_deleted_resource
        raise NotFound if scrapbook.respond_to?(:deleted_at) && scrapbook.deleted_at
      end #raise_if_deleted_resource
    end # Enforcer
  end # Scrapbook
end # Belinkr

