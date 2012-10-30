# encoding: utf-8
require_relative '../../Tinto/Context'
require_relative '../../Tinto/Exceptions'
require_relative '../Workspace/Util'
require_relative '../Workspace/Membership/Collection'

module Belinkr
  class UndeleteWorkspace
    include Tinto::Context
    include Tinto::Exceptions
    include Workspace::Util

    attr_accessor :administrators

    def initialize(actor, workspace, workspaces, tracker)
      @actor          = actor
      @workspace      = workspace
      @workspaces     = workspaces
      @administrators = administrators_for(@workspace)
      @tracker        = tracker
    end # initialize

    def call
      raise NotAllowed unless @administrators.include? @actor
      @workspace.verify
      @workspaces.add @workspace
      @tracker.each { |memberships| memberships.add @workspace }

      @to_sync = [@workspace, @workspaces, @tracker].flatten
      @workspace
    end # call
  end # UndeleteWorkspace
end # Belinkr

