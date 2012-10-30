# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../App/Contexts/CreateWorkspace'
require_relative '../../App/Contexts/DeleteWorkspace'
require_relative '../../App/Workspace/Collection'
require_relative '../../App/Workspace/Util'
require_relative '../../App/Workspace/Membership/Tracker'
require_relative '../Factories/Workspace'
require_relative '../Factories/Entity'
require_relative '../Factories/User'

include Belinkr
include Workspace::Util

describe 'delete workspace' do
  before do
    @entity     = Factory.entity
    @actor      = Factory.user(entity_id: @entity.id)
    @workspace  = Workspace::Member.new(name: 'workspace 1')
    @workspaces = Workspace::Collection.new(entity_id: @entity.id, kind: 'all')
    @workspaces.reset
    @tracker    = Workspace::Membership::Tracker.new(@entity.id, @workspace.id)
                    .reset
    CreateWorkspace.new(@actor, @workspace, @workspaces, @entity, @tracker).call
  end

  it 'deletes the workspace from the workspace collection of the entity' do
    @workspaces.must_include @workspace
    context = DeleteWorkspace.new(@actor, @workspace, @workspaces, @tracker)
    context.administrators.reset
    context.administrators.add @actor
    context.call
    @workspaces.wont_include @workspace
  end

  it 'deletes the workspace from the memberships of all collaborators' do
    (1..5).map { |user_id| @tracker.add 'collaborator', user_id }
    memberships = @tracker.map { |m| m.reset.add(@workspace) }
    context = DeleteWorkspace.new(@actor, @workspace, @workspaces, memberships)
    context.administrators.reset
    context.administrators.add @actor

    memberships.first.must_include @workspace
    context.call
    memberships.first.wont_include @workspace
  end

  it 'deletes the workspace from the memberships of all administrators' do
    (1..5).map { |user_id| @tracker.add 'administrator', user_id }
    memberships = @tracker.map { |m| m.reset.add(@workspace) }
    context = DeleteWorkspace.new(@actor, @workspace, @workspaces, memberships)
    context.administrators.reset
    context.administrators.add @actor

    memberships.to_a.first.must_include @workspace
    context.call
    memberships.to_a.first.wont_include @workspace
  end

  it 'deletes the workspace from the memberships of all invited' do
    (1..5).map { |user_id| @tracker.add 'invited', user_id }
    memberships = @tracker.map { |m| m.reset.add(@workspace) }
    context = DeleteWorkspace.new(@actor, @workspace, @workspaces, memberships)
    context.administrators.reset
    context.administrators.add @actor

    memberships.to_a.first.must_include @workspace
    context.call
    memberships.to_a.first.wont_include @workspace
  end

  it 'deletes the workspace from the memberships of all autoinvited' do
    (1..5).map { |user_id| @tracker.add 'autoinvited', user_id }
    memberships = @tracker.map { |m| m.reset.add(@workspace) }
    context = DeleteWorkspace.new(@actor, @workspace, @workspaces, memberships)
    context.administrators.reset
    context.administrators.add @actor

    memberships.to_a.first.must_include @workspace
    context.call
    memberships.to_a.first.wont_include @workspace
  end
end # delete workspace

