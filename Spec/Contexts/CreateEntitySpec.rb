# encoding: utf-8
require 'minitest/autorun'
require_relative '../../App/Contexts/CreateEntity'
require_relative '../../App/Entity/Collection'
require_relative '../Factories/Entity'

include Belinkr

describe 'create entity' do
  before do
    @entity   = Factory.entity
    @entities = Entity::Collection.new.reset
  end

  it 'adds an entity to the entities collection' do
    @entities.wont_include @entity
    CreateEntity.new(@entity, @entities).call
    @entities.must_include @entity
  end
end # create entity

