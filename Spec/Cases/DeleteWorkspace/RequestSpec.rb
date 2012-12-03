# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require 'json'
require 'redis'
require_relative '../../../Cases/DeleteWorkspace/Request'
require_relative '../../Factories/User'
require_relative '../../Factories/Workspace'

$redis ||= Redis.new
$redis.select 8

include Belinkr

describe 'request model for DeleteWorkspace' do
  it 'returns data object for the context' do
    entity      = OpenStruct.new(id: 0)
    actor       = OpenStruct.new
    workspace   = Factory.workspace(entity_id: entity.id).sync
    workspaces  = Workspace::Collection.new(entity_id: entity.id)

    payload     = { workspace_id: workspace.id }
    payload     = JSON.parse(payload.to_json)
    data        = DeleteWorkspace::Request.new(payload, actor, entity).prepare

    data.fetch(:actor)                .must_equal actor
    data.fetch(:workspace).id         .must_equal workspace.id
    data.fetch(:workspaces).entity_id .must_equal workspace.entity_id
    data.fetch(:enforcer)             .must_be_instance_of Workspace::Enforcer
    data.fetch(:tracker)              .must_be_instance_of Workspace::Tracker
  end
end # request model for DeleteWorkspace

