# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../../Cases/CreateEntity/Context'

include Belinkr

describe 'create entity' do
  it 'adds an entity to the entities collection' do
    entity    = OpenStruct.new
    entities  = Minitest::Mock.new
    context   = CreateEntity::Context.new(entity: entity, entities: entities)

    entities.expect :add, entity, [entity]
    context.call
    entities.verify
  end
end # create entity

