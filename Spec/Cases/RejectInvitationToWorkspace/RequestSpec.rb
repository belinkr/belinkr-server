# encoding: utf-8
require 'minitest/autorun'
require 'redis'

require_relative '../../Factories/Entity'
require_relative '../../Factories/User'
require_relative '../../Factories/Workspace'
require_relative '../../../Cases/RejectInvitationToWorkspace/Request'

$redis ||= Redis.new
$redis.select 8

include Belinkr

describe 'accept invitation to workspace request model' do
  before { $redis.flushdb }

  it 'returns data objects for the RejectInvitationToWorkspace context' do
    entity      = Factory.entity.sync
    inviter     = Factory.user.sync
    actor       = Factory.user.sync
    workspace   = Factory.workspace(entity_id: entity.id).sync
    invitation  = Workspace::Invitation::Member.new(
                    inviter_id:   inviter.id,
                    invited_id:   actor.id,
                    workspace_id: workspace.id,
                    entity_id:    entity.id
                  ).sync
    payload     = { 
                    invitation_id:  invitation.id,
                    workspace_id:   workspace.id 
                  }

    payload     = JSON.parse(payload.to_json)
    arguments   = { payload: payload, actor: actor, entity: entity }
    data        = RejectInvitationToWorkspace::Request.new(arguments).prepare

    data.fetch(:actor).id       .must_equal actor.id
    data.fetch(:enforcer)       
      .must_be_instance_of Workspace::Invitation::Enforcer
    data.fetch(:workspace).id   .must_equal workspace.id
    data.fetch(:invitation).id  .must_equal invitation.id
    data.fetch(:tracker)        .must_be_instance_of Workspace::Tracker
  end
end

