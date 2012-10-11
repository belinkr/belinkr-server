# encoding: utf-8
require_relative '../Entity/Collection'

class CreateEntity
  def initialize(entity)
    @entity   = entity
    @entities = Entity::Collection.new
  end # initialize

  def call
    @entity.save
    @entities.add @entity
    @entity
  end # call
end # CreateEntity

