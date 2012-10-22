# encoding: utf-8
require 'minitest/autorun'
require_relative '../../App/Contexts/DeleteEntity'
require_relative '../../App/Contexts/CreateEntity'
require_relative '../../App/Entity/Collection'
require_relative '../Factories/Entity'

include Belinkr

describe 'delete entity' do 
  before do
    @entity   = Factory.entity
    @entities = Entity::Collection.new.reset
    CreateEntity.new(@entity, @entities).call
  end
  it 'marks the entity as deleted' do
    @entity.deleted_at.must_be_nil
    DeleteEntity.new(@entity, @entities).call
    @entity.deleted_at.wont_be_nil
  end

  it 'removes it from the entities collection' do
    @entities.must_include @entity
    DeleteEntity.new(@entity, @entities).call
    @entities.wont_include @entity
  end
end # delete entity

