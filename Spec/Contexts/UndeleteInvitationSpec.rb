# encoding: utf-8
require 'minitest/autorun'
require_relative '../../App/Contexts/InvitePersonToBelinkr'
require_relative '../../App/Contexts/DeleteInvitation'
require_relative '../../App/Contexts/UndeleteInvitation'
require_relative '../../App/Invitation/Collection'
require_relative '../../Workers/Mailer/Message'
require_relative '../Factories/Invitation'
require_relative '../Factories/Entity'
require_relative '../Factories/User'

include Belinkr

describe 'delete invitation' do
  before do
    @entity       = Factory.entity
    @invitation   = Factory.invitation(entity_id: @entity.id)
    @invitations  = Invitation::Collection.new(entity_id: @entity.id).reset
    @actor        = Factory.user(entity_id: @entity.id)
    @message      = Mailer::Message.new
    InvitePersonToBelinkr.new(@actor, @invitation, @invitations, @entity,
      @message).call
    DeleteInvitation.new(@actor, @invitation, @invitations, @entity).call
  end

  it 'marks the invitation as not deleted' do
    @invitation.deleted_at.wont_be_nil
    UndeleteInvitation.new(@actor, @invitation, @invitations, @entity).call
    @invitation.deleted_at.must_be_nil
  end

  it 'adds the invitation to the invitations collection of the entity' do
    UndeleteInvitation.new(@actor, @invitation, @invitations, @entity).call
    @invitations.must_include @invitation
  end
end

