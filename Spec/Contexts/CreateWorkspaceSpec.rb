# encoding: utf-8
require 'minitest/autorun'
require_relative '../../App/Contexts/CreateWorkspace'
require_relative '../../App/Workspace/Collection'
require_relative '../../App/Workspace/Util'
require_relative '../../App/Workspace/Membership/Tracker'
require_relative '../Factories/Workspace'
require_relative '../Factories/Entity'
require_relative '../Factories/User'

include Belinkr
include Workspace::Util

describe 'create workspace' do
  before do
    @entity     = Factory.entity
    @actor      = Factory.user(entity_id: @entity.id)
    @workspace  = Workspace::Member.new(name: 'workspace 1')
    @workspaces = Workspace::Collection.new(entity_id: @entity.id, kind: 'all')
    @tracker    = Workspace::Membership::Tracker.new(@entity.id, @workspace.id)
    @workspaces.reset
    @tracker.reset
  end

  it 'adds the workspace to the workspace collection of the entity' do
    @workspaces.wont_include @workspace
    CreateWorkspace.new(@actor, @workspace, @workspaces, @entity, @tracker)
      .call
    @workspaces.must_include @workspace
  end

  it 'adds the actor to the administrators collection' do
    @workspace.entity_id = @entity.id
    administrators = administrators_for(@workspace)
    administrators.reset

    context =
      CreateWorkspace.new(@actor, @workspace, @workspaces, @entity, @tracker)
    context.administrators.reset
    context.call
    context.administrators.must_include @actor
  end

  it 'adds the workspace to the administrator memberships of the actor' do
    administrator_memberships = memberships_for(@actor, @entity, 'administrator')
    administrator_memberships.reset

    context = 
      CreateWorkspace.new(@actor, @workspace, @workspaces, @entity, @tracker)
    context.administrator_memberships.reset
    context.call
    context.administrator_memberships.must_include @workspace
  end

  it 'tracks the membership of the administrator' do
    @tracker.to_a.must_be_empty
    context = 
      CreateWorkspace.new(@actor, @workspace, @workspaces, @entity, @tracker)
    context.administrator_memberships.reset
    context.call
    context.administrator_memberships.must_include @workspace
    @tracker.map.first.user_id.must_equal @actor.id
  end
end # create workspace

