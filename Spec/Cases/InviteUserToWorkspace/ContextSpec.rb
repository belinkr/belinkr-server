require 'minitest/autorun'
require 'ostruct'
require_relative '../../../Cases/InviteUserToWorkspace/Context'
require_relative '../../Doubles/Collection/Double'
require_relative '../../Doubles/Enforcer/Double'
require_relative '../../Doubles/Workspace/Invitation/Double'
require_relative '../../Doubles/Workspace/TrackerDouble'

include Belinkr

describe 'invite user to workspace' do
  before do
    @actor                  = OpenStruct.new
    @invited                = OpenStruct.new
    @enforcer               = Enforcer::Double.new
    @workspace              = OpenStruct.new
    @invitation             = Workspace::Invitation::Double.new
    @invitations            = Collection::Double.new
    @tracker                = Workspace::TrackerDouble.new
  end

  it 'authorizes the actor' do
    enforcer  = Minitest::Mock.new
    context   = InviteUserToWorkspace::Context.new(
      actor:                  @actor,
      invited:                @invited,
      enforcer:               enforcer,
      workspace:              @workspace,
      invitation:             @invitation,
      invitations:            @invitations,
      tracker:                @tracker
    )
    enforcer.expect :authorize, true, [@actor, :invite]
    context.call
    enforcer.verify
  end

  it 'links the invitation to the workspace' do
    invitation  = Minitest::Mock.new
    context     = InviteUserToWorkspace::Context.new(
      actor:                  @actor,
      invited:                @invited,
      enforcer:               @enforcer,
      workspace:              @workspace,
      invitation:             invitation,
      invitations:            @invitations,
      tracker:                @tracker
    )
    invitation.expect :link_to, invitation, [{
                        inviter:    @actor,
                        invited:    @invited,
                        workspace:  @workspace
                      }]
    context.call
    invitation.verify
  end

  it 'adds the invitation to the invitations collection' do
    invitations = Minitest::Mock.new
    context     = InviteUserToWorkspace::Context.new(
      actor:                  @actor,
      invited:                @invited,
      enforcer:               @enforcer,
      workspace:              @workspace,
      invitation:             @invitation,
      invitations:            invitations,
      tracker:                @tracker
    )
    invitations.expect :add, invitations, [@invitation]
    context.call
    invitations.verify
  end

  it 'tracks the user as invited' do
    tracker   = Minitest::Mock.new
    context   = InviteUserToWorkspace::Context.new(
      actor:                  @actor,
      invited:                @invited,
      enforcer:               @enforcer,
      workspace:              @workspace,
      invitation:             @invitation,
      invitations:            @invitations,
      tracker:                tracker
    )
    tracker.expect :register, tracker, [@workspace, @invited, :invited]
    context.call
    tracker.verify
  end
end # invite user to workspace

