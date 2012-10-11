# encoding: utf-8
require 'minitest/autorun'
require 'redis'
require_relative '../../App/Contexts/UndeleteEntity'
require_relative '../../App/Contexts/CreateEntity'
require_relative '../../App/Contexts/DeleteEntity'
require_relative '../Factories/Entity'
require_relative '../../App/Entity/Collection'

$redis ||= Redis.new
$redis.select 8

include Belinkr

describe 'undelete entity' do
  before do
    $redis.flushdb
    @entity   = Factory.entity
    @entities = Entity::Collection.new
    CreateEntity.new(@entity).call
    DeleteEntity.new(@entity).call
  end

  it 'marks the entity as not deleted' do
    @entity.deleted_at.wont_be_nil
    UndeleteEntity.new(@entity).call
    @entity.deleted_at.must_be_nil
  end

  it 'adds the entity to the entities collection' do
    @entities.wont_include @entity
    UndeleteEntity.new(@entity).call
    @entities.must_include @entity
  end
end # undelete entity
