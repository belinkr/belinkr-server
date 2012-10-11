# encoding: utf-8
require 'minitest/autorun'
require 'redis'
require_relative '../../App/Contexts/CreateEntity'
require_relative '../../App/Entity/Collection'
require_relative '../Factories/Entity'

$redis ||= Redis.new
$redis.select 8

include Belinkr

describe 'create entity' do
  before do
    $redis.flushdb
    @entity   = Factory.entity
    @entities = Entity::Collection.new
  end

  it 'saves a new entity' do
    @entity.created_at.must_be_nil
    CreateEntity.new(@entity).call
    @entity.created_at.wont_be_nil
  end

  it 'adds it to the entities collection' do
    @entities.wont_include @entity
    CreateEntity.new(@entity).call
    @entities.must_include @entity
  end
end
