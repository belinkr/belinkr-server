# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../../Cases/DeleteInvitation/Context'
require_relative '../../Doubles/Invitation/Double'
require_relative '../../Doubles/Collection/Double'
require_relative '../../Doubles/Enforcer/Double'

include Belinkr

describe 'delete invitation' do
  before do
    @enforcer    = Enforcer::Double.new
    @actor       = OpenStruct.new
    @invitation  = Invitation::Double.new
    @invitations = Collection::Double.new
  end

  it 'authorizes the actor' do
    enforcer  = Minitest::Mock.new
    context   = DeleteInvitation::Context.new(
      enforcer:     enforcer,
      actor:        @actor,
      invitation:   @invitation,
      invitations:  @invitations
    )

    enforcer.expect :authorize, enforcer, [@actor, :delete]
    context.call
    enforcer.verify
  end

  it 'marks the invitation as deleted' do
    invitation  = Minitest::Mock.new
    context     = DeleteInvitation::Context.new(
      enforcer:     @enforcer,
      actor:        @actor,
      invitation:   invitation,
      invitations:  @invitations
    )
    invitation.expect :delete, invitation
    context.call
    invitation.verify
  end

  it 'deletes the invitation from the invitations collection of the entity' do
    invitations = Minitest::Mock.new
    context     = DeleteInvitation::Context.new(
      enforcer:     @enforcer,
      actor:        @actor,
      invitation:   @invitation,
      invitations:  invitations
    )
    invitations.expect :delete, invitations, [@invitation]
    context.call
    invitations.verify
  end
end # delete invitation

