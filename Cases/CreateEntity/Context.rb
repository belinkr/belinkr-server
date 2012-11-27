# encoding: utf-8
require 'Tinto/Context'

module Belinkr
  module CreateEntity
    class Context
      include Tinto::Context
      
      def initialize(arguments)
        @entity   = arguments.fetch(:entity)
        @entities = arguments.fetch(:entities)
      end # initialize

      def call
        entities.add entity
        will_sync entity, entities
      end # call

      private

      attr_reader :entity, :entities
    end # Context
  end # CreateEntity
end # Belinkr

