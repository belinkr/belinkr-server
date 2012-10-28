# encoding: utf-8
require 'minitest/autorun'
require_relative '../../App/Contexts/EditWorkspace'
require_relative '../../App/Contexts/CreateWorkspace'
require_relative '../../App/Workspace/Collection'
require_relative '../../App/Workspace/Util'
require_relative '../../App/Workspace/Membership/Tracker'
require_relative '../Factories/Workspace'
require_relative '../Factories/User'
require_relative '../Factories/Entity'
require_relative '../../Tinto/Exceptions'

include Belinkr
include Workspace::Util

describe 'create workspace' do
  before do
    @entity     = Factory.entity
    @actor      = Factory.user(entity_id: @entity.id)
    @workspace  = Workspace::Member.new(name: 'workspace 1')
    @workspaces = Workspace::Collection.new(entity_id: @entity.id, kind: 'all')
    @tracker    = Workspace::Membership::Tracker.new(@entity.id, @workspace.id)
    @changes    = { name: 'changed' }
    @workspaces.reset

    context = 
      CreateWorkspace.new(@actor, @workspace, @workspaces, @entity, @tracker)
    @administrators = context.administrators
    context.administrators.reset
    context.call
  end

  it 'applies changes to workspace data' do
    @workspace.name.must_equal 'workspace 1'
    EditWorkspace.new(@actor, @workspace, @changes, @administrators).call
    @workspace.name.must_equal 'changed'
  end

  it 'raises NotAllowed if user is not an admininstrator' do
    collaborator = Factory.user(entity_id: @entity.id)
    @administrators.wont_include collaborator
    lambda { 
      EditWorkspace.new(Factory.user, @workspace, @changes, @administrators)
      .call 
    }.must_raise Tinto::Exceptions::NotAllowed
  end
end # edit workspace

