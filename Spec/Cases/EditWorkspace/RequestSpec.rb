# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require 'redis'
require 'json'
require_relative '../../../Cases/EditWorkspace/Request'

include Belinkr
$redis ||= Redis.new
$redis.select 8

describe 'request model for EditWorkspace' do
  before { $redis.flushdb }

  it 'returns data objects for the context' do
    entity    = OpenStruct.new(id: 0)
    actor     = OpenStruct.new(id: 1)
    workspace = Workspace::Member.new(
                  name: 'workspace 1',
                  entity_id: entity.id
                ).sync
    
    payload = { workspace_id: workspace.id, name: 'changed' }
    payload = JSON.parse(payload.to_json)
    data    = EditWorkspace::Request.new(payload, actor, entity).prepare

    data.fetch(:actor)              .must_equal actor
    data.fetch(:workspace).id       .must_equal workspace.id
    data.fetch(:workspace_changes)  .must_equal payload
    data.fetch(:enforcer)           .must_be_instance_of Workspace::Enforcer
  end
end # request model for EditWorkspace

