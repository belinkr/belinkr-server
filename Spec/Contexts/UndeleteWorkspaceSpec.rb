# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../App/Contexts/CreateWorkspace'
require_relative '../../App/Contexts/DeleteWorkspace'
require_relative '../../App/Contexts/UndeleteWorkspace'
require_relative '../../App/Workspace/Collection'
require_relative '../../App/Workspace/Util'
require_relative '../../App/Workspace/Membership/Tracker'
require_relative '../Factories/Workspace'
require_relative '../Factories/Entity'
require_relative '../Factories/User'

include Belinkr
include Workspace::Util

describe 'undelete workspace' do
  before do
    @entity     = Factory.entity
    @actor      = Factory.user(entity_id: @entity.id)
    @workspace  = Workspace::Member.new(name: 'workspace 1')
    @workspaces = Workspace::Collection.new(entity_id: @entity.id, kind: 'all')
    @workspaces.reset
    @tracker    = Workspace::Membership::Tracker.new(@entity.id, @workspace.id)
                    .reset
    (1..5).map { |user_id| @tracker.add 'collaborator', user_id }

    CreateWorkspace.new(@actor, @workspace, @workspaces, @entity, @tracker).call

    @memberships = @tracker.map { |m| m.reset.add(@workspace) }
    context = DeleteWorkspace.new(@actor, @workspace, @workspaces, @memberships)
    context.administrators.reset
    context.administrators.add @actor
    context.call
  end

  it 'adds the workspace to the workspace collection of the entity' do
    @workspaces.wont_include @workspace
    context = UndeleteWorkspace.new(@actor, @workspace, @workspaces, @tracker)
    context.administrators.reset
    context.administrators.add @actor
    context.call
    @workspaces.must_include @workspace
  end

  it 'adds the workspace to the memberships of all collaborators' do
    context = UndeleteWorkspace
              .new(@actor, @workspace, @workspaces, @memberships)
    context.administrators.reset
    context.administrators.add @actor

    @memberships.first.wont_include @workspace
    context.call
    @memberships.first.must_include @workspace
  end
end # undelete workspace

