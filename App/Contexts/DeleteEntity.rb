# encoding: utf-8
require_relative '../Entity/Collection'

module Belinkr
  class DeleteEntity
    def initialize(entity)
      @entity   = entity
      @entities = Entity::Collection.new
    end # initialize

    def call
      $redis.multi do
        @entity.delete
        @entities.remove @entity
      end
      @entity
    end # call
  end # DeleteEntity
end # Belinkr

