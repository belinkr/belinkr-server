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
    @memberships_as_invited       = Collection::Double.new
    @memberships_as_collaborator  = Collection::Double.new
  end

  it 'authorizes the actor' do
    enforcer  = Minitest::Mock.new
    context   = AcceptInvitationToWorkspace::Context.new(
      actor:                        @actor,
      enforcer:                     enforcer,
      workspace:                    @workspace,
      invitation:                   @invitation,
      tracker:                      @tracker,
      memberships_as_invited:       @memberships_as_invited,
      memberships_as_collaborator:  @memberships_as_collaborator
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
      tracker:                      @tracker,
      memberships_as_invited:       @memberships_as_invited,
      memberships_as_collaborator:  @memberships_as_collaborator
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
      tracker:                      @tracker,
      memberships_as_invited:       @memberships_as_invited,
      memberships_as_collaborator:  @memberships_as_collaborator
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
      tracker:                      tracker,
      memberships_as_invited:       @memberships_as_invited,
      memberships_as_collaborator:  @memberships_as_collaborator
    )

    tracker.expect :delete, tracker, [:invited, @actor.id]
    tracker.expect :add,    tracker, [:collaborator, @actor.id]
    context.call
    tracker.verify
  end

  it 'creates a collaborator membership' do
    memberships_as_invited      = Minitest::Mock.new
    memberships_as_collaborator = Minitest::Mock.new

    memberships_as_invited.expect :delete, memberships_as_invited, [@workspace]
    memberships_as_collaborator.expect :add, memberships_as_collaborator, 
                                                [@workspace]

    context   = AcceptInvitationToWorkspace::Context.new(
      actor:                        @actor,
      enforcer:                     @enforcer,
      workspace:                    @workspace,
      invitation:                   @invitation,
      tracker:                      @tracker,
      memberships_as_invited:       memberships_as_invited,
      memberships_as_collaborator:  memberships_as_collaborator
    )
    context.call
    memberships_as_invited.verify
    memberships_as_collaborator.verify
  end
end # accept invitation to workspace

