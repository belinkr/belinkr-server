# encoding: utf-8
require_relative '../../Tinto/Context'

module Belinkr
  class DeleteWorkspace
    include Tinto::Context

    def initialize(arguments)
      @enforcer   = arguments.fetch(:enforcer)
      @actor      = arguments.fetch(:actor)
      @workspace  = arguments.fetch(:workspace)
      @workspaces = arguments.fetch(:workspaces)
      @tracker    = arguments.fetch(:tracker)
    end # initialize

    def call
      enforcer.authorize(actor, :delete)
      workspaces.delete(workspace)
      tracker.unlink_from_all(workspace)

      will_sync workspace, workspaces, tracker
    end # call
    
    private

    attr_reader :enforcer, :actor, :workspace, :workspaces, :tracker
  end # DeleteWorkspace
end # Belinkr

