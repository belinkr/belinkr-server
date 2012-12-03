# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../../Cases/CreateWorkspace/Context'
require_relative '../../Doubles/Collection/Double'
require_relative '../../Doubles/Workspace/Double'
require_relative '../../Doubles/Workspace/TrackerDouble'

include Belinkr

describe 'create workspace' do
  before do
    @actor                        = OpenStruct.new
    @entity                       = OpenStruct.new
    @workspace                    = Workspace::Double.new
    @workspaces                   = Collection::Double.new
    @tracker                      = Workspace::TrackerDouble.new
  end

  it 'links the workspace to the entity' do
    workspace = Minitest::Mock.new
    context   = CreateWorkspace::Context.new(
      actor:                        @actor,
      workspace:                    workspace,
      workspaces:                   @workspaces,
      entity:                       @entity,
      tracker:                      @tracker
    )
    workspace.expect :link_to, workspace, [@entity]  
    context.call
    workspace.verify
  end

  it 'adds the workspace to the workspace collection of the entity' do
    workspaces  = Minitest::Mock.new
    context     = CreateWorkspace::Context.new(
      actor:                        @actor,
      workspace:                    @workspace,
      workspaces:                   workspaces,
      entity:                       @entity,
      tracker:                      @tracker
    )
    workspaces.expect :add, workspaces, [@workspace]
    context.call
    workspaces.verify
  end

  it 'tracks the actor as an administrator' do
    tracker = Minitest::Mock.new
    context         = CreateWorkspace::Context.new(
      actor:                        @actor,
      workspace:                    @workspace,
      workspaces:                   @workspaces,
      entity:                       @entity,
      tracker:                      tracker
    )
    tracker.expect :track_administrator, tracker, [@workspace, @actor]
    context.call
    tracker.verify
  end
end # create workspace

