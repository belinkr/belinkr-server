# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../../Cases/DeleteEntity/Context'
require_relative '../../Doubles/Collection/Double'

include Belinkr

describe 'delete entity' do 
  it 'marks the entity as deleted' do
    entity    = Minitest::Mock.new
    entities  = Collection::Double.new
    context   = DeleteEntity::Context.new(entity: entity, entities: entities)

    entity.expect :delete, entity
    context.call
    entity.verify
  end

  it 'removes it from the entities collection' do
    entity    = OpenStruct.new
    entities  = Minitest::Mock.new
    context   = DeleteEntity::Context.new(entity: entity, entities: entities)

    entities.expect :delete, entities, [entity]
    context.call
    entities.verify
  end
end # delete entity

