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
  end

  it 'authorizes the actor' do
    enforcer  = Minitest::Mock.new
    context   = RejectAutoinvitationToWorkspace::Context.new(
      actor:                      @actor,
      autoinvited:                @autoinvited,
      enforcer:                   enforcer,
      workspace:                  @workspace,
      autoinvitation:             @autoinvitation,
      tracker:                    @tracker
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
      tracker:                    @tracker
    )

    autoinvitation.expect :reject, autoinvitation
    context.call
    autoinvitation.verify
  end

  it 'untracks the user as autoinvited' do
    tracker = Minitest::Mock.new
    context = RejectAutoinvitationToWorkspace::Context.new(
      actor:                      @actor,
      autoinvited:                @autoinvited,
      enforcer:                   @enforcer,
      workspace:                  @workspace,
      autoinvitation:             @autoinvitation,
      tracker:                    tracker
    )
    tracker.expect :unregister, tracker, 
                    [@workspace, @autoinvited, :autoinvited]
    context.call
    tracker.verify
  end
end # reject autoinvitation to workspace

