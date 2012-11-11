require 'minitest/autorun'
require 'ostruct'
require_relative '../../../Cases/AutoinviteToWorkspace/Context'
require_relative '../../Doubles/Collection/Double'
require_relative '../../Doubles/Enforcer/Double'
require_relative '../../Doubles/Workspace/Autoinvitation/Double'
require_relative '../../Doubles/Workspace/TrackerDouble'

include Belinkr

describe 'autoinvite to workspace' do
  before do
    @actor                      = OpenStruct.new
    @enforcer                   = Enforcer::Double.new
    @workspace                  = OpenStruct.new
    @autoinvitation             = Workspace::Autoinvitation::Double.new
    @autoinvitations            = Collection::Double.new
    @tracker                    = Workspace::TrackerDouble.new
    @memberships_as_autoinvited = Collection::Double.new
  end

  it 'authorizes the actor' do
    enforcer  = Minitest::Mock.new
    context   = AutoinviteToWorkspace::Context.new(
      actor:                      @actor,
      enforcer:                   enforcer,
      workspace:                  @workspace,
      autoinvitation:             @autoinvitation,
      autoinvitations:            @autoinvitations,
      tracker:                    @tracker,
      memberships_as_autoinvited: @memberships_as_autoinvited
    )
    enforcer.expect :authorize, true, [@actor, :autoinvite]
    context.call
    enforcer.verify
  end

  it 'links the autoinvitation to the workspace' do
    autoinvitation  = Minitest::Mock.new
    context     = AutoinviteToWorkspace::Context.new(
      actor:                      @actor,
      enforcer:                   @enforcer,
      workspace:                  @workspace,
      autoinvitation:             autoinvitation,
      autoinvitations:            @autoinvitations,
      tracker:                    @tracker,
      memberships_as_autoinvited: @memberships_as_autoinvited
    )
    autoinvitation.expect :link_to, autoinvitation, [{
                            autoinvited:  @actor,
                            workspace:    @workspace
                          }]
    context.call
    autoinvitation.verify
  end

  it 'adds the autoinvitation to the autoinvitations collection' do
    autoinvitations = Minitest::Mock.new
    context     = AutoinviteToWorkspace::Context.new(
      actor:                      @actor,
      enforcer:                   @enforcer,
      workspace:                  @workspace,
      autoinvitation:             @autoinvitation,
      autoinvitations:            autoinvitations,
      tracker:                    @tracker,
      memberships_as_autoinvited: @memberships_as_autoinvited
    )
    autoinvitations.expect :add, autoinvitations, [@autoinvitation]
    context.call
    autoinvitations.verify
  end

  it 'adds the workspace to the autoinvited collection of the user' do
    memberships_as_autoinvited = Minitest::Mock.new
    context   = AutoinviteToWorkspace::Context.new(
      actor:                      @actor,
      enforcer:                   @enforcer,
      workspace:                  @workspace,
      autoinvitation:             @autoinvitation,
      autoinvitations:            @autoinvitations,
      tracker:                    @tracker,
      memberships_as_autoinvited: memberships_as_autoinvited
    )
    memberships_as_autoinvited.expect :add, memberships_as_autoinvited, [@workspace]
    context.call
    memberships_as_autoinvited.verify
  end

  it 'registers the autoinvitation membership in the workspace tracker' do
    tracker = Minitest::Mock.new
    context = AutoinviteToWorkspace::Context.new(
      actor:                      @actor,
      enforcer:                   @enforcer,
      workspace:                  @workspace,
      autoinvitation:             @autoinvitation,
      autoinvitations:            @autoinvitations,
      tracker:                    tracker,
      memberships_as_autoinvited: @memberships_as_autoinvited
    )
    tracker.expect :add, tracker, [:autoinvited, @actor.id]
    context.call
    tracker.verify
  end
end # autoinvite to workspace

