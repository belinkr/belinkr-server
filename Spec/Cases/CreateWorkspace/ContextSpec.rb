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
    @administrators               = Collection::Double.new
    @memberships_as_administrator = Collection::Double.new
    @tracker                      = Workspace::TrackerDouble.new
  end

  it 'links the workspace to the entity' do
    workspace = Minitest::Mock.new
    context   = CreateWorkspace::Context.new(
      actor:                        @actor,
      workspace:                    workspace,
      workspaces:                   @workspaces,
      entity:                       @entity,
      tracker:                      @tracker,
      administrators:               @administrators,
      memberships_as_administrator: @memberships_as_administrator
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
      tracker:                      @tracker,
      administrators:               @administrators,
      memberships_as_administrator: @memberships_as_administrator
    )
    workspaces.expect :add, workspaces, [@workspace]
    context.call
    workspaces.verify
  end

  it 'adds the actor to the administrators collection' do
    administrators  = Minitest::Mock.new
    context         = CreateWorkspace::Context.new(
      actor:                        @actor,
      workspace:                    @workspace,
      workspaces:                   @workspaces,
      entity:                       @entity,
      tracker:                      @tracker,
      administrators:               administrators,
      memberships_as_administrator: @memberships_as_administrator
    )
    administrators.expect :add, administrators, [@actor]
    context.call
    administrators.verify
  end

  it 'adds the workspace to the administrator memberships of the actor' do
    memberships_as_administrator = Minitest::Mock.new
    context   = CreateWorkspace::Context.new(
      actor:                        @actor,
      workspace:                    @workspace,
      workspaces:                   @workspaces,
      entity:                       @entity,
      tracker:                      @tracker,
      administrators:               @administrators,
      memberships_as_administrator: memberships_as_administrator
    )
    memberships_as_administrator.expect :add, nil, [@workspace]
    context.call
    memberships_as_administrator.verify
  end

  it 'tracks the membership of the administrator' do
    tracker   = Minitest::Mock.new
    context   = CreateWorkspace::Context.new(
      actor:                        @actor,
      workspace:                    @workspace,
      workspaces:                   @workspaces,
      entity:                       @entity,
      tracker:                      tracker,
      administrators:               @administrators,
      memberships_as_administrator: @memberships_as_administrator
    )
    tracker.expect :add, tracker, [:administrator, @actor.id]
    context.call
    tracker.verify
  end
end # create workspace

