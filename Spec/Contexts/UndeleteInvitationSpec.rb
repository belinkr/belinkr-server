# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../App/Contexts/UndeleteInvitation'
require_relative '../Doubles/Invitation/Double'
require_relative '../Doubles/Collection/Double'

include Belinkr

describe 'undelete invitation' do
  it 'marks the invitation as not deleted' do
    actor       = OpenStruct.new
    invitation  = Minitest::Mock.new
    invitations = Collection::Double.new
    context     = UndeleteInvitation.new(
      actor:        actor,
      invitation:   invitation,
      invitations:  invitations
    )

    invitation.expect :authorize, invitation, [actor, :undelete]
    invitation.expect :undelete, invitation
    context.call
    invitation.verify
  end

  it 'adds the invitation to the invitations collection of the entity' do
    actor       = OpenStruct.new
    invitation  = Invitation::Double.new
    invitations = Minitest::Mock.new
    context     = UndeleteInvitation.new(
      actor:        actor,
      invitation:   invitation,
      invitations:  invitations
    )

    invitations.expect :add, invitations, [invitation]
    context.call
    invitations.verify
  end
end # undelete invitation

