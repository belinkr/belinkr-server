# encoding: utf-8
require_relative './User/Collection'

module Belinkr
  module Workspace
    class Relator
      def initialize(workspace)
        @workspace = workspace
      end #initialize

      def collaborators
        user_collection('collaborator')
      end #collaborators

      def administrators
        user_collection('administrator')
      end #administrators

      def invited
        user_collection('invited')
      end #invited

      def autoinvited
        user_collection('autoinvited')
      end #autoinvited

      def is_in?(user)
        is_administrator?(user) || is_collaborator?(user)
      end #is_in?

      def is_administrator?(user)
        administrators.include?(user)
      end #is_administrator?

      def is_collaborator?(user)
        collaborators.include?(user)
      end #is_collaborator?

      def is_invited?(user)
        invited.include?(user)
      end #invited

      def is_autoinvited?(user)
        autoinvited.include?(user)
      end #autoinvited

      private

      attr_reader :workspace

      def user_collection(kind)
        Workspace::User::Collection.new(
          workspace_id: workspace.id, 
          entity_id:    workspace.entity_id,
          kind:         kind
        )
      end #user_collection
    end # Util
  end # Workspace
end # Belinkr

