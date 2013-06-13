# encoding: utf-8
require 'Tinto/Exceptions'
require_relative '../../Services/Tracker'

module Belinkr
  module Workspace
    class Enforcer
      include Tinto::Exceptions

      ADMINISTRATOR_ACTIONS = %w{ update delete undelete promote demote
                                  remove get_status get_timeline }
      COLLABORATOR_ACTIONS  = %w{create leave create_status get_timeline}
      ACTIONS               = COLLABORATOR_ACTIONS + ADMINISTRATOR_ACTIONS

      def initialize(workspace, tracker=Workspace::Tracker.new)
        @workspace      = workspace
        @tracker        = tracker
      end #initialize

      def authorize(actor, action)
        return true if action =~ /collection/

        raise NotAllowed unless is_in?(actor)
        raise NotAllowed if evil_collaborator?(actor, action)
        return true
      end #authorize

      private

      attr_reader :workspace, :tracker

      def is_in?(actor)
        relationship = tracker.relationship_for(workspace, actor)
        relationship == 'collaborator' || relationship == 'administrator'
      end

      def evil_collaborator?(actor, action)
        tracker.relationship_for(workspace, actor) == 'collaborator' &&
        !COLLABORATOR_ACTIONS.include?(action.to_s)
      end #evil_collaborator?
    end # Enforcer
  end # Workspace
end # Belinkr

