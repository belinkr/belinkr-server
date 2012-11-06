# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../App/Contexts/EditWorkspace'
require_relative '../Doubles/Workspace/Double'
require_relative '../Doubles/Enforcer/Double'

include Belinkr

describe 'edit workspace' do
  it 'authorizes the actor' do
    enforcer          = Minitest::Mock.new
    actor             = OpenStruct.new
    workspace_changes = { name: 'changed' }
    workspace         = Workspace::Double.new

    context = EditWorkspace.new(
      enforcer:           enforcer,
      actor:              actor, 
      workspace:          workspace, 
      workspace_changes:  workspace_changes
    )
    enforcer.expect :authorize, enforcer, [actor, :update]
    context.call
    enforcer.verify
  end

  it 'applies changes to workspace data' do
    enforcer          = Enforcer::Double.new
    actor             = OpenStruct.new
    workspace_changes = { name: 'changed' }
    workspace         = Minitest::Mock.new

    context = EditWorkspace.new(
      enforcer:           enforcer,
      actor:              actor, 
      workspace:          workspace, 
      workspace_changes:  workspace_changes
    )
    workspace.expect :update, workspace, [workspace_changes]
    context.call
    workspace.verify
  end
end # edit workspace

