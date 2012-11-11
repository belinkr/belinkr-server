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
    @memberships_as_invited = Collection::Double.new
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
      tracker:                @tracker,
      memberships_as_invited: @memberships_as_invited
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
      tracker:                @tracker,
      memberships_as_invited: @memberships_as_invited
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
      tracker:                @tracker,
      memberships_as_invited: @memberships_as_invited
    )
    invitations.expect :add, invitations, [@invitation]
    context.call
    invitations.verify
  end

  it 'adds the workspace to the invited collection of the user' do
    memberships_as_invited = Minitest::Mock.new
    context   = InviteUserToWorkspace::Context.new(
      actor:                  @actor,
      invited:                @invited,
      enforcer:               @enforcer,
      workspace:              @workspace,
      invitation:             @invitation,
      invitations:            @invitations,
      tracker:                @tracker,
      memberships_as_invited: memberships_as_invited
    )
    memberships_as_invited.expect :add, memberships_as_invited, [@workspace]
    context.call
    memberships_as_invited.verify
  end

  it 'registers the invitation membership in the workspace tracker' do
    tracker = Minitest::Mock.new
    context   = InviteUserToWorkspace::Context.new(
      actor:                  @actor,
      invited:                @invited,
      enforcer:               @enforcer,
      workspace:              @workspace,
      invitation:             @invitation,
      invitations:            @invitations,
      tracker:                tracker,
      memberships_as_invited: @memberships_as_invited
    )
    tracker.expect :add, tracker, [:invited, @actor.id]
    context.call
    tracker.verify
  end
end # invite user to workspace

