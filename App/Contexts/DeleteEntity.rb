# encoding: utf-8
require_relative '../Entity/Collection'
require_relative '../../Tinto/Context'

module Belinkr
  class DeleteEntity
    include Tinto::Context

    def initialize(entity, entities=Entity::Collection.new)
      @entity   = entity
      @entities = entities
    end # initialize

    def call
      @entity.delete
      @entities.delete @entity

      @to_sync = [@entity, @entities]
      @entity
    end # call
  end # DeleteEntity
end # Belinkr

