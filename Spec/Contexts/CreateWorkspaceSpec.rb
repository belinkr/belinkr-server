# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../App/Contexts/CreateWorkspace'
require_relative '../Doubles/Collection/Double'
require_relative '../Doubles/Workspace/Double'
require_relative '../Doubles/Workspace/TrackerDouble'

include Belinkr

describe 'create workspace' do
  before do
    @actor                      = OpenStruct.new
    @entity                     = OpenStruct.new
    @workspace                  = Workspace::Double.new
    @workspaces                 = Collection::Double.new
    @administrators             = Collection::Double.new
    @administrator_memberships  = Collection::Double.new
    @tracker                    = Workspace::TrackerDouble.new
  end

  it 'links the workspace to the entity' do
    workspace = Minitest::Mock.new
    context   = CreateWorkspace.new(
      actor:                      @actor,
      workspace:                  workspace,
      workspaces:                 @workspaces,
      entity:                     @entity,
      tracker:                    @tracker,
      administrators:             @administrators,
      administrator_memberships:  @administrator_memberships
    )
    workspace.expect :link_to, workspace, [@entity]  
    context.call
    workspace.verify
  end

  it 'adds the workspace to the workspace collection of the entity' do
    workspaces  = Minitest::Mock.new
    context     = CreateWorkspace.new(
      actor:                      @actor,
      workspace:                  @workspace,
      workspaces:                 workspaces,
      entity:                     @entity,
      tracker:                    @tracker,
      administrators:             @administrators,
      administrator_memberships:  @administrator_memberships
    )
    workspaces.expect :add, workspaces, [@workspace]
    context.call
    workspaces.verify
  end

  it 'adds the actor to the administrators collection' do
    administrators  = Minitest::Mock.new
    context         = CreateWorkspace.new(
      actor:                      @actor,
      workspace:                  @workspace,
      workspaces:                 @workspaces,
      entity:                     @entity,
      tracker:                    @tracker,
      administrators:             administrators,
      administrator_memberships:  @administrator_memberships
    )
    administrators.expect :add, administrators, [@actor]
    context.call
    administrators.verify
  end

  it 'adds the workspace to the administrator memberships of the actor' do
    administrator_memberships = Minitest::Mock.new
    context   = CreateWorkspace.new(
      actor:                      @actor,
      workspace:                  @workspace,
      workspaces:                 @workspaces,
      entity:                     @entity,
      tracker:                    @tracker,
      administrators:             @administrators,
      administrator_memberships:  administrator_memberships
    )
    administrator_memberships.expect :add, nil, [@workspace]
    context.call
    administrator_memberships.verify
  end

  it 'tracks the membership of the administrator' do
    tracker   = Minitest::Mock.new
    context   = CreateWorkspace.new(
      actor:                      @actor,
      workspace:                  @workspace,
      workspaces:                 @workspaces,
      entity:                     @entity,
      tracker:                    tracker,
      administrators:             @administrators,
      administrator_memberships:  @administrator_memberships
    )
    tracker.expect :add, tracker, ['administrator', @actor.id]
    context.call
    tracker.verify
  end
end # create workspace

