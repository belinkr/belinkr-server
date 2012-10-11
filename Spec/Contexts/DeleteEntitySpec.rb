# encoding: utf-8
require 'minitest/autorun'
require 'redis'
require_relative '../../App/Contexts/DeleteEntity'
require_relative '../../App/Contexts/CreateEntity'
require_relative '../../App/Entity/Collection'
require_relative '../Factories/Entity'

$redis ||= Redis.new
$redis.select 8

include Belinkr

describe 'delete entity' do 
  before do
    $redis.flushdb
    @entity   = Factory.entity
    @entities = Entity::Collection.new
    CreateEntity.new(@entity).call
  end
  it 'marks the entity as deleted' do
    @entity.deleted_at.must_be_nil
    DeleteEntity.new(@entity).call
    @entity.deleted_at.wont_be_nil
  end

  it 'removes it from the entities collection' do
    @entities.must_include @entity
    DeleteEntity.new(@entity).call
    @entities.wont_include @entity
  end
end # delete entity
