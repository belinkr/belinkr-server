# encoding: utf-8
require 'Tinto/Context'

module Belinkr
  module DeleteEntity
    class Context
      include Tinto::Context

      def initialize(arguments)
        @entity   = arguments.fetch(:entity)
        @entities = arguments.fetch(:entities)
      end # initialize

      def call
        entity.delete
        entities.delete entity

        will_sync entity, entities
      end # call

      private

      attr_reader :entity, :entities
    end # Context
  end # DeleteEntity
end # Belinkr

