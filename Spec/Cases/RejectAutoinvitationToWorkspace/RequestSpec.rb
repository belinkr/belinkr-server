# encoding: utf-8
require 'minitest/autorun'
require 'redis'

require_relative '../../Factories/Entity'
require_relative '../../Factories/User'
require_relative '../../Factories/Workspace'
require_relative '../../../Cases/RejectAutoinvitationToWorkspace/Request'

$redis ||= Redis.new
$redis.select 8

include Belinkr

describe 'accept autoinvitation to workspace request model' do
  before { $redis.flushdb }

  it 'returns data objects for the RejectAutoinvitationToWorkspace context' do
    entity          = Factory.entity.sync
    actor           = Factory.user.sync
    workspace       = Factory.workspace(entity_id: entity.id).sync
    autoinvitation  = Workspace::Autoinvitation::Member.new(
                        workspace_id:   workspace.id,
                        entity_id:      entity.id,
                        autoinvited_id: actor.id
                      ).sync
    payload         = { id: autoinvitation.id, workspace_id: workspace.id }
    payload         = JSON.parse(payload.to_json)
    request         = RejectAutoinvitationToWorkspace::Request
                        .new(payload, actor, entity)
    data            = request.prepare

    data.fetch(:actor).id           .must_equal actor.id
    data.fetch(:workspace).id       .must_equal workspace.id
    data.fetch(:autoinvitation).id  .must_equal autoinvitation.id
    data.fetch(:autoinvited).id     .must_equal actor.id
    data.fetch(:enforcer)
      .must_be_instance_of Workspace::Autoinvitation::Enforcer
    data.fetch(:tracker)        .must_be_instance_of Workspace::Tracker
  end
end

