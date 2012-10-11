# encoding: utf-8
require 'minitest/autorun'
require 'redis'
require_relative '../../App/Contexts/AcceptInvitationAndJoinEntity'
require_relative '../../App/Contexts/InvitePersonToBelinkr'
require_relative '../../App/Activity/Collection'
require_relative '../../Workers/Mailer/Message'
require_relative '../Factories/Invitation'
require_relative '../Factories/User'
require_relative '../Factories/Entity'

$redis ||= Redis.new
$redis.select 8

include Belinkr

describe 'accept invitation and join' do
  before do
    @entity     = Factory.entity.save
    @inviter    = Factory.user(entity_id: @entity.id).save
    @invitation = Factory.invitation(entity_id: @entity.id)
    @actor      = Factory.user(profile_ids: [], entity_ids: [])

    InvitePersonToBelinkr.new(@inviter, @invitation, @entity).call
  end

  it 'marks the invitation as accepted' do
    @invitation.accepted?.must_equal false
    AcceptInvitationAndJoinEntity.new(@actor, @invitation, @entity).call
    @invitation.accepted?.must_equal true
  end

  it 'saves the actor' do
    previously_saved_at = @actor.updated_at
    AcceptInvitationAndJoinEntity.new(@actor, @invitation, @entity).call
    @actor.updated_at.wont_equal previously_saved_at
  end

  it 'generates a profile for the actor' do
    @actor.profile_ids.must_be_empty
    @actor.entity_ids.must_be_empty
    AcceptInvitationAndJoinEntity.new(@actor, @invitation, @entity).call
    @actor.profile_ids.wont_be_empty
    @actor.entity_ids.wont_be_empty
  end

  it 'registers an activity' do
    AcceptInvitationAndJoinEntity.new(@actor, @invitation, @entity).call
    activity = Activity::Collection.new(entity_id: @entity.id).all.first
    activity.action.must_equal 'accept'
    activity.object.resource.id.must_equal @invitation.id
  end
end
