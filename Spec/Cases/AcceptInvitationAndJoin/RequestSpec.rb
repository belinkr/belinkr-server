# encoding: utf-8
require 'minitest/autorun'
require 'redis'
require_relative '../../../Cases/AcceptInvitationAndJoin/Request'
require_relative '../../Factories/Entity'
require_relative '../../Factories/Invitation'

$redis ||= Redis.new
$redis.select 8

include Belinkr

describe 'request model for AcceptInvitationAndJoin' do
  it 'prepares data objects for context' do
    entity      = Factory.entity.sync
    invitation  = Factory.invitation(entity_id: entity.id).sync

    payload = { invitation_id: invitation.id }
    payload = JSON.parse(payload.to_json)
    data    = AcceptInvitationAndJoin::Request.new(payload).prepare

    data.fetch(:actor)          .must_be_instance_of User::Member
    data.fetch(:invitation).id  .must_equal invitation.id
    data.fetch(:entity).id      .must_equal entity.id
    data.fetch(:profile)        .must_be_instance_of Profile::Member
    data.fetch(:profiles)       .must_be_instance_of Profile::Collection
  end
end # request model for AcceptInvitationAndJoin

