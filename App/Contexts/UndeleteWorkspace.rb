# encoding: utf-8
require_relative '../../Tinto/Context'

module Belinkr
  class UndeleteWorkspace
    include Tinto::Context

    def initialize(arguments)
      @actor      = arguments.fetch(:actor)
      @workspace  = arguments.fetch(:workspace)
      @workspaces = arguments.fetch(:workspaces)
      @tracker    = arguments.fetch(:tracker)
    end # initialize

    def call
      workspace.authorize(actor, :undelete)
      workspaces.add(workspace)
      tracker.link_to_all(workspace)

      will_sync workspace, workspaces, tracker
    end # call

    private

    attr_reader :actor, :workspace, :workspaces, :tracker
  end # UndeleteWorkspace
end # Belinkr

