require 'minitest/autorun'
require 'ostruct'
require_relative '../../../Cases/AcceptAutoinvitationToWorkspace/Context'
require_relative '../../Doubles/Collection/Double'
require_relative '../../Doubles/Enforcer/Double'
require_relative '../../Doubles/Workspace/Autoinvitation/Double'
require_relative '../../Doubles/Workspace/TrackerDouble'

include Belinkr

describe 'accept autoinvitation to workspace' do
  before do
    @actor                        = OpenStruct.new(id: 1)
    @autoinvited                  = OpenStruct.new(id: 2)
    @enforcer                     = Enforcer::Double.new
    @workspace                    = OpenStruct.new
    @autoinvitation               = Workspace::Autoinvitation::Double.new
    @tracker                      = Workspace::TrackerDouble.new
    @memberships_as_autoinvited   = Collection::Double.new
    @memberships_as_collaborator  = Collection::Double.new
  end

  it 'authorizes the actor' do
    enforcer  = Minitest::Mock.new
    context   = AcceptAutoinvitationToWorkspace::Context.new(
      actor:                        @actor,
      autoinvited:                  @autoinvited,
      enforcer:                     enforcer,
      workspace:                    @workspace,
      autoinvitation:               @autoinvitation,
      tracker:                      @tracker,
      memberships_as_autoinvited:   @memberships_as_autoinvited,
      memberships_as_collaborator:  @memberships_as_collaborator
    )

    enforcer.expect :authorize, true, [@actor, :accept]
    context.call
    enforcer.verify
  end

  it 'marks the autoinvitation as accepted' do
    autoinvitation  = Minitest::Mock.new
    context     = AcceptAutoinvitationToWorkspace::Context.new(
      actor:                        @actor,
      autoinvited:                  @autoinvited,
      enforcer:                     @enforcer,
      workspace:                    @workspace,
      autoinvitation:               autoinvitation,
      tracker:                      @tracker,
      memberships_as_autoinvited:   @memberships_as_autoinvited,
      memberships_as_collaborator:  @memberships_as_collaborator
    )

    autoinvitation.expect :accept, autoinvitation
    context.call
    autoinvitation.verify
  end

  it 'increments the user counter of the workspace' do
    workspace = Minitest::Mock.new
    context   = AcceptAutoinvitationToWorkspace::Context.new(
      actor:                        @actor,
      autoinvited:                  @autoinvited,
      enforcer:                     @enforcer,
      workspace:                    workspace,
      autoinvitation:               @autoinvitation,
      tracker:                      @tracker,
      memberships_as_autoinvited:   @memberships_as_autoinvited,
      memberships_as_collaborator:  @memberships_as_collaborator
    )

    workspace.expect :increment_user_counter, workspace
    context.call
    workspace.verify
  end

  it 'tracks the user as a collaborator' do
    tracker = Minitest::Mock.new
    context = AcceptAutoinvitationToWorkspace::Context.new(
      actor:                        @actor,
      autoinvited:                  @autoinvited,
      enforcer:                     @enforcer,
      workspace:                    @workspace,
      autoinvitation:               @autoinvitation,
      tracker:                      tracker,
      memberships_as_autoinvited:   @memberships_as_autoinvited,
      memberships_as_collaborator:  @memberships_as_collaborator
    )

    tracker.expect :accept, tracker, [@workspace, @autoinvited, :autoinvited]
    context.call
    tracker.verify
  end
end # accept autoinvitation to workspace

