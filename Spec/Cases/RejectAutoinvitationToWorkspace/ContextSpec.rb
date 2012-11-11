require 'minitest/autorun'
require 'ostruct'
require_relative '../../../Cases/RejectAutoinvitationToWorkspace/Context'
require_relative '../../Doubles/Collection/Double'
require_relative '../../Doubles/Enforcer/Double'
require_relative '../../Doubles/Workspace/Autoinvitation/Double'
require_relative '../../Doubles/Workspace/TrackerDouble'

include Belinkr

describe 'autoinvite user to workspace' do
  before do
    @actor                      = OpenStruct.new(id: 1)
    @autoinvited                = OpenStruct.new(id: 2)
    @enforcer                   = Enforcer::Double.new
    @workspace                  = OpenStruct.new
    @autoinvitation             = Workspace::Autoinvitation::Double.new
    @tracker                    = Workspace::TrackerDouble.new
    @memberships_as_autoinvited = Collection::Double.new
  end

  it 'authorizes the actor' do
    enforcer  = Minitest::Mock.new
    context   = RejectAutoinvitationToWorkspace::Context.new(
      actor:                      @actor,
      autoinvited:                @autoinvited,
      enforcer:                   enforcer,
      workspace:                  @workspace,
      autoinvitation:             @autoinvitation,
      tracker:                    @tracker,
      memberships_as_autoinvited: @memberships_as_autoinvited
    )
    enforcer.expect :authorize, true, [@actor, :reject]
    context.call
    enforcer.verify
  end

  it 'marks the autoinvitation as rejected' do
    autoinvitation  = Minitest::Mock.new
    context         = RejectAutoinvitationToWorkspace::Context.new(
      actor:                      @actor,
      autoinvited:                @autoinvited,
      enforcer:                   @enforcer,
      workspace:                  @workspace,
      autoinvitation:             autoinvitation,
      tracker:                    @tracker,
      memberships_as_autoinvited: @memberships_as_autoinvited
    )

    autoinvitation.expect :reject, autoinvitation
    context.call
    autoinvitation.verify
  end

  it 'removes the workspace from the memberhips as autoinvited of the user' do
    memberships_as_autoinvited  = Minitest::Mock.new
    context                     = RejectAutoinvitationToWorkspace::Context.new(
      actor:                      @actor,
      autoinvited:                @autoinvited,
      enforcer:                   @enforcer,
      workspace:                  @workspace,
      autoinvitation:             @autoinvitation,
      tracker:                    @tracker,
      memberships_as_autoinvited: memberships_as_autoinvited
    )
    memberships_as_autoinvited.expect :delete, memberships_as_autoinvited, [@workspace]
    context.call
    memberships_as_autoinvited.verify
  end

  it 'deletes the autoinvited membership in the workspace tracker' do
    tracker = Minitest::Mock.new
    context = RejectAutoinvitationToWorkspace::Context.new(
      actor:                      @actor,
      autoinvited:                @autoinvited,
      enforcer:                   @enforcer,
      workspace:                  @workspace,
      autoinvitation:             @autoinvitation,
      tracker:                    tracker,
      memberships_as_autoinvited: @memberships_as_autoinvited
    )
    tracker.expect :delete, tracker, [:autoinvited, @autoinvited.id]
    context.call
    tracker.verify
  end
end # reject autoinvitation to workspace

