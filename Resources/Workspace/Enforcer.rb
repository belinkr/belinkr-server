# encoding: utf-8
require 'Tinto/Exceptions'
require_relative '../../Services/Tracker'

module Belinkr
  module Workspace
    class Enforcer
      include Tinto::Exceptions

      ADMINISTRATOR_ACTIONS = %w{ update delete undelete promote demote remove }
      COLLABORATOR_ACTIONS  =  %w{ create leave }
      ACTIONS               = COLLABORATOR_ACTIONS + ADMINISTRATOR_ACTIONS

      def initialize(workspace, tracker=Workspace::Tracker.new)
        @workspace      = workspace
        @tracker        = tracker
      end #initialize

      def authorize(actor, action)
        raise NotAllowed unless is_in?(actor)
        raise NotAllowed if evil_collaborator?(actor, action)
        return true
      end #authorize

      private

      attr_reader :workspace, :tracker

      def is_in?(actor)
        tracker.is?(workspace, actor, :collaborator) ||
        tracker.is?(workspace, actor, :administrator)
      end

      def evil_collaborator?(actor, action)
        tracker.is?(workspace, actor, :collaborator) &&
        !COLLABORATOR_ACTIONS.include?(action)
      end #evil_collaborator?
    end # Enforcer
  end # Workspace
end # Belinkr

