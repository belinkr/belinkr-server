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
  end

  it 'authorizes the actor' do
    enforcer  = Minitest::Mock.new
    context   = AutoinviteToWorkspace::Context.new(
      actor:                      @actor,
      enforcer:                   enforcer,
      workspace:                  @workspace,
      autoinvitation:             @autoinvitation,
      autoinvitations:            @autoinvitations,
      tracker:                    @tracker
    )
    enforcer.expect :authorize, true, [@actor, :autoinvite, @actor]
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
      tracker:                    @tracker
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
      tracker:                    @tracker
    )
    autoinvitations.expect :add, autoinvitations, [@autoinvitation]
    context.call
    autoinvitations.verify
  end

  it 'tracks the user as autoinvited' do
    tracker = Minitest::Mock.new
    context = AutoinviteToWorkspace::Context.new(
      actor:                      @actor,
      enforcer:                   @enforcer,
      workspace:                  @workspace,
      autoinvitation:             @autoinvitation,
      autoinvitations:            @autoinvitations,
      tracker:                    tracker
    )
    tracker.expect :track_autoinvitation, tracker,
                    [@workspace, @actor, @autoinvitation]
    context.call
    tracker.verify
  end
end # autoinvite to workspace

