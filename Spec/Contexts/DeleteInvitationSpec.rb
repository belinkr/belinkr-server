# encoding: utf-8
require 'minitest/autorun'
require 'redis'
require_relative '../../App/Contexts/InvitePersonToBelinkr'
require_relative '../../App/Contexts/DeleteInvitation'
require_relative '../../App/Invitation/Collection'
require_relative '../Factories/Invitation'
require_relative '../Factories/Entity'
require_relative '../Factories/User'

include Belinkr

$redis ||= Redis.new
$redis.select 8

describe 'delete invitation' do
  before do
    @entity       = Factory.entity
    @invitation   = Factory.invitation(entity_id: @entity.id)
    @actor        = Factory.user(entity_id: @entity.id)
    @invitations  = Invitation::Collection.new(entity_id: @entity.id)
    InvitePersonToBelinkr.new(@actor, @invitation, @invitations, @entity).call
  end

  it 'marks the invitation as deleted' do
    @invitation.deleted_at.must_be_nil
    DeleteInvitation.new(@actor, @invitation, @invitations, @entity).call
    @invitation.deleted_at.wont_be_nil
  end

  it 'removes the invitation from the invitations collection of the entity' do
    DeleteInvitation.new(@actor, @invitation, @invitations, @entity).call
    @invitations.wont_include @invitation
  end
end
