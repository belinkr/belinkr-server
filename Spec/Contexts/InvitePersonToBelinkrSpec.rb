# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../App/Contexts/InvitePersonToBelinkr'
require_relative '../Doubles/Collection/Double'
require_relative '../Doubles/Invitation/Double'
require_relative '../Doubles/Message/Double'

include Belinkr

describe 'invite user to Belinkr' do
  before do
    @actor        = OpenStruct.new
    @invitation   = Invitation::Double.new
    @invitations  = Collection::Double.new
    @entity       = OpenStruct.new
    @message      = Message::Double.new
  end
 
  it 'links the invitation to the actor' do
    invitation = Minitest::Mock.new
    context = InvitePersonToBelinkr.new(
      actor:        @actor,
      entity:       @entity,
      invitation:   invitation,
      invitations:  @invitations,
      message:      @message
    )
    context.register_activity_context = OpenStruct.new
    
    invitation.expect :link_to, invitation, [@actor]
    context.call
    invitation.verify
  end

  it 'adds the invitation to the invitations collection' do
    invitations = Minitest::Mock.new
    context = InvitePersonToBelinkr.new(
      actor:        @actor,
      entity:       @entity,
      invitation:   @invitation,
      invitations:  invitations,
      message:      @message
    )
    context.register_activity_context = OpenStruct.new

    invitations.expect :add, invitations, [@invitation]
    context.call
    invitations.verify
  end

  it 'prepares a password invitation e-mail' do
    message = Minitest::Mock.new
    context = InvitePersonToBelinkr.new(
      actor:        @actor,
      entity:       @entity,
      invitation:   @invitation,
      invitations:  @invitations,
      message:      message
    )
    context.register_activity_context = OpenStruct.new

    message.expect :prepare, message, 
                      [:invitation_for, @actor, @invitation, @entity] 
    context.call
    message.verify
  end
end # invite user to Belinkr

