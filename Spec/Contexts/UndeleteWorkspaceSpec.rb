# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require 'set'
require_relative '../../App/Contexts/UndeleteWorkspace'
require_relative '../Doubles/Collection/Double'
require_relative '../Doubles/Workspace/Double'
require_relative '../Doubles/Workspace/TrackerDouble'
require_relative '../Doubles/Enforcer/Double'

include Belinkr

describe 'delete workspace' do
  before do
    @enforcer   = Enforcer::Double.new
    @actor      = OpenStruct.new
    @workspace  = Workspace::Double.new
    @workspaces = Collection::Double.new
    @tracker    = Workspace::TrackerDouble.new
  end

  it 'authorizes the actor' do
    enforcer  = Minitest::Mock.new
    context   = UndeleteWorkspace.new(
      enforcer:   enforcer,
      workspace:  @workspace,
      actor:      @actor,
      workspaces: @workspaces,
      tracker:    @tracker
    )
    enforcer.expect :authorize, true, [@actor, :undelete]
    context.call
    enforcer.verify
  end

  it 'adds the workspace to the workspace collection of the entity' do
    workspaces  = Minitest::Mock.new
    context     = UndeleteWorkspace.new(
      enforcer:   @enforcer,
      workspace:  @workspace,
      actor:      @actor,
      workspaces: workspaces,
      tracker:    @tracker
    )
    workspaces.expect :add, true, [@workspace]
    context.call
    workspaces.verify
  end

  it 'adds the workspace to the memberships of all users involved' do
    tracker = Minitest::Mock.new
    context = UndeleteWorkspace.new(
      enforcer:   @enforcer,
      workspace:  @workspace,
      actor:      @actor,
      workspaces: @workspaces,
      tracker:    tracker
    )

    tracker.expect :link_to_all, true, [@workspace]
    context.call
    tracker.verify
  end

  it 'will sync the workspace, workspaces and tracker' do
    context = UndeleteWorkspace.new(
      enforcer:   @enforcer,
      workspace:  @workspace,
      actor:      @actor,
      workspaces: @workspaces,
      tracker:    @tracker
    )
    context.call
    context.syncables.must_include @workspace
    context.syncables.must_include @workspaces
    context.syncables.must_include @tracker
  end
end # delete workspace

