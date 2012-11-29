# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'

require_relative '../../../Cases/LeaveWorkspace/Context'
require_relative '../../Doubles/Workspace/Double'
require_relative '../../Doubles/Enforcer/Double'
require_relative '../../Doubles/Workspace/TrackerDouble'

include Belinkr

describe 'leave workspace' do
  before do
    @actor      = OpenStruct.new
    @workspace  = Workspace::Double.new
    @enforcer   = Enforcer::Double.new
    @tracker    = Workspace::TrackerDouble.new
  end

  it 'authorizes the actor' do
    enforcer  = Minitest::Mock.new
    context   = LeaveWorkspace::Context.new(
      actor:      @actor,
      workspace:  @workspace,
      enforcer:   enforcer,
      tracker:    @tracker
    )
    enforcer.expect :authorize, true, [@actor, :leave]
    context.call
    enforcer.verify
  end

  it 'removes the actor from the workspace' do
    tracker   = Minitest::Mock.new
    context   = LeaveWorkspace::Context.new(
      actor:      @actor,
      workspace:  @workspace,
      enforcer:   @enforcer,
      tracker:    tracker
    )
    tracker.expect :remove, tracker, [@workspace, @actor]
    context.call
    tracker.verify
  end
end # leave workspace
