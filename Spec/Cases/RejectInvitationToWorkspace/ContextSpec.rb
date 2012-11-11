require 'minitest/autorun'
require 'ostruct'
require_relative '../../../Cases/RejectInvitationToWorkspace/Context'
require_relative '../../Doubles/Collection/Double'
require_relative '../../Doubles/Enforcer/Double'
require_relative '../../Doubles/Workspace/Invitation/Double'
require_relative '../../Doubles/Workspace/TrackerDouble'

include Belinkr

describe 'invite user to workspace' do
  before do
    @actor                  = OpenStruct.new
    @enforcer               = Enforcer::Double.new
    @workspace              = OpenStruct.new
    @invitation             = Workspace::Invitation::Double.new
    @tracker                = Workspace::TrackerDouble.new
    @memberships_as_invited = Collection::Double.new
  end

  it 'authorizes the actor' do
    enforcer  = Minitest::Mock.new
    context   = RejectInvitationToWorkspace::Context.new(
      actor:                  @actor,
      enforcer:               enforcer,
      workspace:              @workspace,
      invitation:             @invitation,
      tracker:                @tracker,
      memberships_as_invited: @memberships_as_invited
    )
    enforcer.expect :authorize, true, [@actor, :reject]
    context.call
    enforcer.verify
  end

  it 'marks the invitation as rejected' do
    invitation  = Minitest::Mock.new
    context     = RejectInvitationToWorkspace::Context.new(
      actor:                        @actor,
      enforcer:                     @enforcer,
      workspace:                    @workspace,
      invitation:                   invitation,
      tracker:                      @tracker,
      memberships_as_invited:       @memberships_as_invited
    )

    invitation.expect :reject, invitation
    context.call
    invitation.verify
  end

  it 'removes the workspace from the memberhips as invited of the user' do
    memberships_as_invited  = Minitest::Mock.new
    context                 = RejectInvitationToWorkspace::Context.new(
      actor:                  @actor,
      enforcer:               @enforcer,
      workspace:              @workspace,
      invitation:             @invitation,
      tracker:                @tracker,
      memberships_as_invited: memberships_as_invited
    )
    memberships_as_invited.expect :delete, memberships_as_invited, [@workspace]
    context.call
    memberships_as_invited.verify
  end

  it 'deletes the invited membership in the workspace tracker' do
    tracker = Minitest::Mock.new
    context = RejectInvitationToWorkspace::Context.new(
      actor:                  @actor,
      enforcer:               @enforcer,
      workspace:              @workspace,
      invitation:             @invitation,
      tracker:                tracker,
      memberships_as_invited: @memberships_as_invited
    )
    tracker.expect :delete, tracker, [:invited, @actor.id]
    context.call
    tracker.verify
  end
end # reject invitation to workspace

