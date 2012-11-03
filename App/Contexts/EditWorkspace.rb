# encoding: utf-8
require_relative '../../Tinto/Context'

module Belinkr
  class EditWorkspace
    include Tinto::Context

    def initialize(arguments)
      @actor              = arguments.fetch(:actor)
      @workspace          = arguments.fetch(:workspace)
      @workspace_changes  = arguments.fetch(:workspace_changes)
    end #initialize

    def call
      workspace.authorize(actor, :update)
      workspace.update(workspace_changes)

      will_sync workspace
    end # call

    private

    attr_reader :actor, :workspace, :workspace_changes
  end # EditWorkspace
end # Belinkr

