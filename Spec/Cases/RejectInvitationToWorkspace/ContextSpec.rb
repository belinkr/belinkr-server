require 'minitest/autorun'
require 'ostruct'
require_relative '../../../Cases/RejectInvitationToWorkspace/Context'
require_relative '../../Doubles/Collection/Double'
require_relative '../../Doubles/Enforcer/Double'
require_relative '../../Doubles/Workspace/Invitation/Double'
require_relative '../../Doubles/Workspace/TrackerDouble'

include Belinkr

describe 'reject invitation to workspace' do
  before do
    @actor          = OpenStruct.new
    @enforcer       = Enforcer::Double.new
    @workspace      = OpenStruct.new
    @invitation     = Workspace::Invitation::Double.new
    @tracker        = Workspace::TrackerDouble.new
  end

  it 'authorizes the actor' do
    enforcer  = Minitest::Mock.new
    context   = RejectInvitationToWorkspace::Context.new(
      actor:        @actor,
      enforcer:     enforcer,
      workspace:    @workspace,
      invitation:   @invitation,
      tracker:      @tracker
    )
    enforcer.expect :authorize, true, [@actor, :reject]
    context.call
    enforcer.verify
  end

  it 'marks the invitation as rejected' do
    invitation  = Minitest::Mock.new
    context     = RejectInvitationToWorkspace::Context.new(
      actor:        @actor,
      enforcer:     @enforcer,
      workspace:    @workspace,
      invitation:   invitation,
      tracker:      @tracker
    )

    invitation.expect :reject, invitation
    context.call
    invitation.verify
  end

  it 'untracks the user as invited' do
    tracker = Minitest::Mock.new
    context = RejectInvitationToWorkspace::Context.new(
      actor:        @actor,
      enforcer:     @enforcer,
      workspace:    @workspace,
      invitation:   @invitation,
      tracker:      tracker
    )
    tracker.expect :untrack_invitation, tracker,
      [@workspace, @actor, @invitation]
    context.call
    tracker.verify
  end
end # reject invitation to workspace

