# encoding: utf-8
require_relative '../../Tinto/Context'

module Belinkr
  class CreateEntity
    include Tinto::Context

    def initialize(entity, entities)
      @entity   = entity
      @entities = entities
    end # initialize

    def call
      @entities.add @entity

      @to_sync = [@entity, @entities]
      @entity
    end # call
  end # CreateEntity
end # Belinkr

