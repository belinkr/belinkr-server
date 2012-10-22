# encoding: utf-8
require 'minitest/autorun'
require_relative '../../App/Contexts/UndeleteEntity'
require_relative '../../App/Contexts/CreateEntity'
require_relative '../../App/Contexts/DeleteEntity'
require_relative '../Factories/Entity'
require_relative '../../App/Entity/Collection'

include Belinkr

describe 'undelete entity' do
  before do
    @entity   = Factory.entity
    @entities = Entity::Collection.new.reset
    CreateEntity.new(@entity, @entities).call
    DeleteEntity.new(@entity, @entities).call
  end

  it 'marks the entity as not deleted' do
    @entity.deleted_at.wont_be_nil
    UndeleteEntity.new(@entity, @entities).call
    @entity.deleted_at.must_be_nil
  end

  it 'adds the entity to the entities collection' do
    @entities.wont_include @entity
    UndeleteEntity.new(@entity, @entities).call
    @entities.must_include @entity
  end
end # undelete entity
