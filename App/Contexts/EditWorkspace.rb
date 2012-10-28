# encoding: utf-8
require_relative '../../Tinto/Exceptions'
require_relative '../../Tinto/Context'
require_relative '../Workspace/Util'

module Belinkr
  class EditWorkspace
    include Tinto::Exceptions
    include Tinto::Context
    include Workspace::Util

    def initialize(actor, workspace, workspace_changes, administrators=nil)
      @actor              = actor
      @workspace          = workspace
      @workspace_changes  = workspace_changes
      @administrators     = administrators || administrators_for(@workspace)
    end #initialize

    def call
      raise NotAllowed unless @administrators.include?(@actor)
      @workspace.update(@workspace_changes)
      @workspace.verify

      @to_sync = [@workspace]
      @workspace
    end # call
  end # EditWorkspace
end # Belinkr

