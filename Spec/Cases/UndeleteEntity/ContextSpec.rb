# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../../Cases/UndeleteEntity/Context'
require_relative '../../Doubles/Collection/Double'

include Belinkr

describe 'undelete entity' do
  it 'marks the entity as not deleted' do
    entity    = Minitest::Mock.new
    entities  = Collection::Double.new
    context   = UndeleteEntity::Context.new(entity: entity, entities: entities)

    entity.expect :undelete, entity
    context.call
    entity.verify
  end

  it 'adds the entity to the entities collection' do
    entity    = OpenStruct.new
    entities  = Minitest::Mock.new
    context   = UndeleteEntity::Context.new(entity: entity, entities: entities)
    entities.expect :add, entities, [entity]
    context.call
    entities.verify
  end
end # undelete entity

