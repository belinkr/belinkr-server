# encoding: utf-8
require 'minitest/autorun'
require 'redis'
require_relative '../../App/Contexts/InvitePersonToBelinkr'
require_relative '../../App/Activity/Collection'
require_relative '../../Workers/Mailer/Message'
require_relative '../Factories/Invitation'
require_relative '../Factories/User'
require_relative '../Factories/Entity'

$redis ||= Redis.new
$redis.select 8

include Belinkr

describe 'invite person to Belinkr' do
  before do
    @entity     = Factory.entity.save
    @invitation = Factory.invitation(entity_id: @entity.id)
    @actor      = Factory.user(entity_id: @entity.id).save
  end

  it 'saves an invitation' do
    @invitation.created_at.must_be_nil
    InvitePersonToBelinkr.new(@actor, @invitation, @entity).call
    @invitation.created_at.wont_be_nil
  end

  it 'generates an activity' do
    InvitePersonToBelinkr.new(@actor, @invitation, @entity).call
    activity = Activity::Collection.new(entity_id: @entity.id).all.first
    activity.action.must_equal 'invite'
    activity.object.resource.must_equal @invitation.invited_name
  end

  it 'schedules an invitation e-mail to be sent' do
    InvitePersonToBelinkr.new(@actor, @invitation, @entity).call
    message = JSON.parse($redis.rpop Belinkr::Mailer::Message::QUEUE_KEY)
    message['substitutions']['invited_name'].must_equal @invitation.invited_name
  end
end # invite person to Belinkr

