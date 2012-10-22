# encoding: utf-8
require 'minitest/autorun'
require 'redis'
require_relative '../../App/Contexts/AcceptInvitationAndJoinEntity'
require_relative '../../App/Contexts/InvitePersonToBelinkr'
require_relative '../../Workers/Mailer/Message'
require_relative '../../App/Invitation/Collection'
require_relative '../Factories/Invitation'
require_relative '../Factories/User'
require_relative '../Factories/Entity'

$redis ||= Redis.new
$redis.select 8

include Belinkr

describe 'accept invitation and join' do
  before do
    @entity       = Factory.entity
    @inviter      = Factory.user(entity_id: @entity.id)
    @invitation   = Factory.invitation(entity_id: @entity.id)
    @invitations  = Invitation::Collection.new(entity_id: @entity.id)
    @actor        = Factory.user(profiles: [])

    InvitePersonToBelinkr.new(@inviter, @invitation, @invitations, @entity).call
  end

  it 'marks the invitation as accepted' do
    @invitation.accepted?.must_equal false
    AcceptInvitationAndJoinEntity.new(@actor, @invitation, @entity).call
    @invitation.accepted?.must_equal true
  end

  it 'generates a profile for the actor' do
    @actor.profiles.must_be_empty
    AcceptInvitationAndJoinEntity.new(@actor, @invitation, @entity).call
    @actor.profiles.wont_be_empty
  end

  it 'registers an activity' do
    skip
    AcceptInvitationAndJoinEntity.new(@actor, @invitation, @entity).call
    activity = Activity::Collection.new(entity_id: @entity.id).all.first
    activity.action.must_equal 'accept'
    activity.object.resource.id.must_equal @invitation.id
  end
end

