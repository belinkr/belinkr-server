# encoding: utf-8
require_relative '../../Tinto/Context'
require_relative '../Workspace/Util'

module Belinkr
  class CreateWorkspace
    include Tinto::Context
    include Workspace::Util

    attr_reader :administrators, :administrator_memberships

    def initialize(actor, workspace, workspaces, entity, tracker)
      @actor                = actor
      @workspace            = workspace
      @workspaces           = workspaces
      @entity               = entity
      @workspace.entity_id  = @entity.id
      @administrators       = administrators_for(@workspace)
      @administrator_memberships = 
        memberships_for(@actor, @entity, 'administrator')
      @tracker              = tracker
    end

    def call
      @workspace.verify
      @workspaces                 .add @workspace
      @administrators             .add @actor
      @administrator_memberships  .add @workspace
      @tracker                    .add 'administrator', @actor.id
      @to_sync = [@workspace, @workspaces, @administrators, 
                  @administrator_memberships, @tracker]
      @workspace
    end #to_sync
  end # CreateWorkspace
end # Belinkr

