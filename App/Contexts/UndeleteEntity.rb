# encoding: utf-8
require_relative '../Entity/Collection'
require_relative '../../Tinto/Context'

module Belinkr
  class UndeleteEntity
    include Tinto::Context

    attr_reader :entity, :entities

    def initialize(arguments)
      @entity   = arguments.fetch(:entity)
      @entities = arguments.fetch(:entities)
    end #initialize

    def call
      entity.undelete
      entities.add entity

      will_sync entity, entities
    end #call
  end # UndeleteEntity
end # Belinkr

