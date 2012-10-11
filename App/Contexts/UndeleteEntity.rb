# encoding: utf-8
require_relative '../Entity/Collection'

class UndeleteEntity
  def initialize(entity)
    @entity   = entity
    @entities = Entity::Collection.new
  end

  def call
    $redis.multi do
      @entity.undelete
      @entities.add @entity
    end
    @entity
  end
end

