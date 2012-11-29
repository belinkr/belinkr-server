require 'minitest/autorun'
require 'ostruct'
require_relative '../../../Cases/AcceptInvitationToWorkspace/Context'
require_relative '../../Doubles/Collection/Double'
require_relative '../../Doubles/Enforcer/Double'
require_relative '../../Doubles/Workspace/Invitation/Double'
require_relative '../../Doubles/Workspace/TrackerDouble'

include Belinkr

describe 'accept invitation to workspace' do
  before do
    @actor                        = OpenStruct.new
    @enforcer                     = Enforcer::Double.new
    @workspace                    = OpenStruct.new
    @invitation                   = Workspace::Invitation::Double.new
    @tracker                      = Workspace::TrackerDouble.new
  end

  it 'authorizes the actor' do
    enforcer  = Minitest::Mock.new
    context   = AcceptInvitationToWorkspace::Context.new(
      actor:                        @actor,
      enforcer:                     enforcer,
      workspace:                    @workspace,
      invitation:                   @invitation,
      tracker:                      @tracker
    )

    enforcer.expect :authorize, true, [@actor, :accept]
    context.call
    enforcer.verify
  end

  it 'marks the invitation as accepted' do
    invitation  = Minitest::Mock.new
    context     = AcceptInvitationToWorkspace::Context.new(
      actor:                        @actor,
      enforcer:                     @enforcer,
      workspace:                    @workspace,
      invitation:                   invitation,
      tracker:                      @tracker
    )

    invitation.expect :accept, invitation
    context.call
    invitation.verify
  end

  it 'increments the user counter of the workspace' do
    workspace = Minitest::Mock.new
    context   = AcceptInvitationToWorkspace::Context.new(
      actor:                        @actor,
      enforcer:                     @enforcer,
      workspace:                    workspace,
      invitation:                   @invitation,
      tracker:                      @tracker
    )

    workspace.expect :increment_user_counter, workspace
    context.call
    workspace.verify
  end

  it 'tracks the user as a collaborator' do
    tracker = Minitest::Mock.new
    context = AcceptInvitationToWorkspace::Context.new(
      actor:                        @actor,
      enforcer:                     @enforcer,
      workspace:                    @workspace,
      invitation:                   @invitation,
      tracker:                      tracker
    )

    tracker.expect :assign_role, tracker,
                    [@workspace, @actor, :collaborator]
    context.call
    tracker.verify
  end
end # accept invitation to workspace

