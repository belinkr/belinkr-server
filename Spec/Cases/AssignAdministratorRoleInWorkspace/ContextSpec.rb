# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../../Cases/AssignAdministratorRoleInWorkspace/Context'
require_relative '../../Doubles/Enforcer/Double'
require_relative '../../Doubles/Workspace/Double'
require_relative '../../Doubles/Workspace/TrackerDouble'

include Belinkr

describe 'assign administrator role in workspace' do
  before do
    @actor        = OpenStruct.new
    @target_user  = OpenStruct.new
    @workspace    = Workspace::Double.new
    @enforcer     = Enforcer::Double.new
    @tracker      = Workspace::TrackerDouble.new
  end

  it 'authorizes the actor' do
    enforcer  = Minitest::Mock.new
    context   = AssignAdministratorRoleInWorkspace::Context.new(
      actor:        @actor,
      target_user:  @target_user,
      workspace:    @workspace,
      enforcer:     enforcer,
      tracker:      @tracker
    )
    enforcer.expect :authorize, true, [@actor, :assign_role]
    context.call
    enforcer.verify
  end

  it 'assigns the administrator role to the target user' do
    tracker = Minitest::Mock.new
    context = AssignAdministratorRoleInWorkspace::Context.new(
      actor:        @actor,
      target_user:  @target_user,
      workspace:    @workspace,
      enforcer:     @enforcer,
      tracker:      tracker
    )
    tracker.expect :assign_role, tracker,
                    [@workspace, @target_user, :administrator]
    context.call
    tracker.verify
  end
end # assign administrator role in workspace

