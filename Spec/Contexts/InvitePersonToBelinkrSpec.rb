# encoding: utf-8
require 'minitest/autorun'
require_relative '../../App/Contexts/InvitePersonToBelinkr'
require_relative '../../App/Invitation/Collection'
require_relative '../../Workers/Mailer/Message'
require_relative '../Factories/Invitation'
require_relative '../Factories/User'
require_relative '../Factories/Entity'

include Belinkr

describe 'invite person to Belinkr' do
  before do
    @entity       = Factory.entity
    @actor        = Factory.user(entity_id: @entity.id)
    @invitation   = Factory.invitation(entity_id: @entity.id)
    @invitations  = Invitation::Collection.new(entity_id: @entity.id).reset
    @message      = Mailer::Message.new
  end

  it 'adds the invitation to the invitations collection' do
    @invitations.wont_include @invitation
    InvitePersonToBelinkr
      .new(@actor, @invitation, @invitations, @entity, @message).call
    @invitations.must_include @invitation
  end
    
  it 'schedules an invitation e-mail to be sent' do
    InvitePersonToBelinkr
      .new(@actor, @invitation, @invitations, @entity, @message).call
    @message.substitutions.fetch(:invited_name)
      .must_equal @invitation.invited_name
  end
end # invite person to Belinkr

