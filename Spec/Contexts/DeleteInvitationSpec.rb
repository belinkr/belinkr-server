# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../App/Contexts/DeleteInvitation'
require_relative '../Doubles/Invitation/Double'
require_relative '../Doubles/Collection/Double'

include Belinkr

describe 'delete invitation' do
  it 'marks the invitation as deleted' do
    actor       = OpenStruct.new
    invitation  = Minitest::Mock.new
    invitations = Collection::Double.new
    context     = DeleteInvitation.new(
      actor:        actor,
      invitation:   invitation,
      invitations:  invitations
    )

    invitation.expect :authorize, invitation, [actor, :delete]
    invitation.expect :delete, invitation
    context.call
    invitation.verify
  end

  it 'deletes the invitation from the invitations collection of the entity' do
    actor       = OpenStruct.new
    invitation  = Invitation::Double.new
    invitations = Minitest::Mock.new
    context     = DeleteInvitation.new(
      actor:        actor,
      invitation:   invitation,
      invitations:  invitations
    )

    invitations.expect :delete, invitations, [invitation]
    context.call
    invitations.verify
  end
end # delete invitation

