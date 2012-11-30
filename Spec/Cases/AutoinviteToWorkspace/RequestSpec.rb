# encoding: utf-8
require 'minitest/autorun'
require 'redis'

require_relative '../../Factories/Entity'
require_relative '../../Factories/User'
require_relative '../../Factories/Workspace'
require_relative '../../../Cases/AutoinviteToWorkspace/Request'

$redis ||= Redis.new
$redis.select 8

include Belinkr

describe 'autoinvite to workspace request model' do
  before { $redis.flushdb }

  it 'returns data objects for the AutoinviteToWorkspace context' do
    entity      = Factory.entity.sync
    actor       = Factory.user.sync
    workspace   = Factory.workspace(entity_id: entity.id).sync
    payload     = {
                    autoinvited_id: actor.id,
                    workspace_id:   workspace.id,
                    entity_id:      entity.id
                  }

    payload     = JSON.parse(payload.to_json)
    request     = AutoinviteToWorkspace::Request.new(payload, actor, entity)
    data        = request.prepare

    data.fetch(:actor).id                       .must_equal actor.id
    data.fetch(:workspace).id                   .must_equal workspace.id
    data.fetch(:autoinvitation).autoinvited_id  .must_equal actor.id
    data.fetch(:autoinvitation).workspace_id    .must_equal workspace.id
    data.fetch(:autoinvitations).workspace_id   .must_equal workspace.id
    data.fetch(:enforcer)
      .must_be_instance_of Workspace::Autoinvitation::Enforcer
    data.fetch(:tracker)  .must_be_instance_of Workspace::Tracker
  end
end

