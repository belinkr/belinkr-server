# encoding: utf-8
require 'minitest/autorun'
require 'redis'

require_relative '../../Factories/Entity'
require_relative '../../Factories/User'
require_relative '../../Factories/Workspace'
require_relative '../../../Cases/InviteUserToWorkspace/Request'

$redis ||= Redis.new
$redis.select 8

include Belinkr

describe 'invite user to workspace request model' do
  before { $redis.flushdb }

  it 'returns data objects for the InviteUserToWorkspace context' do
    entity      = Factory.entity.sync
    actor       = Factory.user.sync
    invited     = Factory.user.sync
    workspace   = Factory.workspace(entity_id: entity.id).sync
    payload     = {
                    inviter_id:   actor.id,
                    invited_id:   invited.id,
                    workspace_id: workspace.id,
                    entity_id:    entity.id
                  }

    payload     = JSON.parse(payload.to_json)
    request     = InviteUserToWorkspace::Request.new(payload, actor, entity)
    data        = request.prepare

    data.fetch(:actor).id                 .must_equal actor.id
    data.fetch(:workspace).id             .must_equal workspace.id
    data.fetch(:invitation).workspace_id  .must_equal workspace.id
    data.fetch(:invitations).workspace_id .must_equal workspace.id
    data.fetch(:invited).id               .must_equal invited.id
    data.fetch(:enforcer) .must_be_instance_of Workspace::Invitation::Enforcer
    data.fetch(:tracker)  .must_be_instance_of Workspace::Tracker
  end
end

