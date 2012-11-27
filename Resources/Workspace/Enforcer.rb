# encoding: utf-8
require 'Tinto/Exceptions'

module Belinkr
  module Workspace
    class Enforcer
      include Tinto::Exceptions

      ADMINISTRATOR_ACTIONS = %w{ update delete undelete promote demote remove }
      COLLABORATOR_ACTIONS  =  %w{ create leave }
      ACTIONS               = COLLABORATOR_ACTIONS + ADMINISTRATOR_ACTIONS

      def initialize(arguments)
        @administrators = arguments.fetch(:administrators)
        @collaborators  = arguments.fetch(:collaborators)
      end #initialize

      def authorize(actor, action)
        raise NotAllowed unless is_in?(actor)
        raise NotAllowed if evil_collaborator?(actor, action)
        return true
      end #authorize

      private

      attr_reader :administrators, :collaborators

      def is_in?(actor)
        administrators.include?(actor) || collaborators.include?(actor)
      end

      def evil_collaborator?(actor, action)
        collaborators.include?(actor) &&
        !COLLABORATOR_ACTIONS.include?(action)
      end #evil_collaborator?
    end # Enforcer
  end # Workspace
end # Belinkr

