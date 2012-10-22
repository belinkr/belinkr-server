# encoding: utf-8
require_relative '../Entity/Collection'
require_relative '../../Tinto/Context'

module Belinkr
  class UndeleteEntity
    include Tinto::Context

    def initialize(entity, entities=Entity::Collection.new)
      @entity   = entity
      @entities = entities
    end #initialize

    def call
      @entity.undelete
      @entities.add @entity

      @to_sync = [@entity, @entities]
      @entity
    end #call
  end # UndeleteEntity
end # Belinkr

