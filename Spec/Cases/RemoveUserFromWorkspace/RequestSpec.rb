# encoding: utf-8

# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require 'json'
require 'redis'
require_relative '../../../Cases/RemoveUserFromWorkspace/Request'
require_relative '../../Factories/User'
require_relative '../../Factories/Workspace'

$redis ||= Redis.new
$redis.select 8

include Belinkr

describe 'request model for RemoveUserFromWorkspace' do
  it 'returns data object for the context' do
    entity      = OpenStruct.new(id: 0)
    target_user = Factory.user.sync
    workspace   = Factory.workspace(entity_id: entity.id).sync
    actor       = OpenStruct.new

    payload     = { 
                    user_id:      target_user.id, 
                    workspace_id: workspace.id 
                  }
    payload     = JSON.parse(payload.to_json)
    arguments   = { payload: payload, actor: actor, entity: entity }
    data        = RemoveUserFromWorkspace::Request.new(arguments).prepare

    data.fetch(:actor)          .must_equal actor
    data.fetch(:target_user).id .must_equal target_user.id
    data.fetch(:workspace).id   .must_equal workspace.id
    data.fetch(:enforcer)       .must_be_instance_of Workspace::Enforcer
    data.fetch(:tracker)        .must_be_instance_of Workspace::Tracker

  end
end # request model for RemoveUserFromWorkspace

