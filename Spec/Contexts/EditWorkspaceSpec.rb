# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../App/Contexts/EditWorkspace'

include Belinkr

describe 'edit workspace' do
  it 'applies changes to workspace data' do
    actor             = OpenStruct.new
    workspace_changes = { name: 'changed' }
    workspace         = Minitest::Mock.new

    context = EditWorkspace.new(
      actor:              actor, 
      workspace:          workspace, 
      workspace_changes:  workspace_changes
    )

    workspace.expect :authorize, workspace, [actor, :update]
    workspace.expect :update, workspace, [workspace_changes]
    context.call
    workspace.verify
  end
end # edit workspace

