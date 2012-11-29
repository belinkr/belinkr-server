# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'

require_relative '../../../Cases/RemoveUserFromWorkspace/Context'
require_relative '../../Doubles/Workspace/Double'
require_relative '../../Doubles/Enforcer/Double'
require_relative '../../Doubles/Workspace/TrackerDouble'

include Belinkr

describe 'remove user from workspace' do
  before do
    @actor        = OpenStruct.new
    @target_user  = OpenStruct.new
    @workspace    = Workspace::Double.new
    @enforcer     = Enforcer::Double.new
    @tracker      = Workspace::TrackerDouble.new
  end

  it 'authorizes the actor' do
    enforcer  = Minitest::Mock.new
    context   = RemoveUserFromWorkspace::Context.new(
      actor:        @actor,
      target_user:  @target_user,
      workspace:    @workspace,
      enforcer:     enforcer,
      tracker:      @tracker
    )
    enforcer.expect :authorize, true, [@actor, :remove]
    context.call
    enforcer.verify
  end

  it 'removes the tor from the workspace' do
    tracker   = Minitest::Mock.new
    context   = RemoveUserFromWorkspace::Context.new(
      actor:        @actor,
      target_user:  @target_user,
      workspace:    @workspace,
      enforcer:     @enforcer,
      tracker:      tracker
    )
    tracker.expect :remove, tracker, [@workspace, @actor]
    context.call
    tracker.verify
  end
end # remove user from workspace

