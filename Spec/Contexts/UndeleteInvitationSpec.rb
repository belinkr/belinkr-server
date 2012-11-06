# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../App/Contexts/UndeleteInvitation'
require_relative '../Doubles/Invitation/Double'
require_relative '../Doubles/Collection/Double'
require_relative '../Doubles/Enforcer/Double'

include Belinkr

describe 'undelete invitation' do
  before do
    @enforcer     = Enforcer::Double.new
    @actor        = OpenStruct.new
    @invitation   = Invitation::Double.new
    @invitations  = Collection::Double.new
  end

  it 'authorizes the actor' do
    enforcer  = Minitest::Mock.new
    context   = UndeleteInvitation.new(
      enforcer:     enforcer,
      actor:        @actor,
      invitation:   @invitation,
      invitations:  @invitations
    )

    enforcer.expect :authorize, enforcer, [@actor, :undelete]
    context.call
    enforcer.verify
  end

  it 'marks the invitation as not deleted' do
    invitation  = Minitest::Mock.new
    context     = UndeleteInvitation.new(
      enforcer:     @enforcer,
      actor:        @actor,
      invitation:   invitation,
      invitations:  @invitations
    )

    invitation.expect :undelete, invitation
    context.call
    invitation.verify
  end

  it 'adds the invitation to the invitations collection of the entity' do
    invitations = Minitest::Mock.new
    context     = UndeleteInvitation.new(
      enforcer:     @enforcer,
      actor:        @actor,
      invitation:   @invitation,
      invitations:  invitations
    )

    invitations.expect :add, invitations, [@invitation]
    context.call
    invitations.verify
  end
end # undelete invitation

