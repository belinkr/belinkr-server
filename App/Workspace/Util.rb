# encoding: utf-8
require_relative './User/Collection'
require_relative './Membership/Collection'

module Belinkr
  module Workspace
    module Util
      def collaborators_for(workspace)
        Workspace::User::Collection.new(
          workspace_id: workspace.id, 
          entity_id:    workspace.entity_id,
          kind:         'collaborator'
        )
      end #collaborators_for

      def administrators_for(workspace)
        Workspace::User::Collection.new(
          workspace_id: workspace.id, 
          entity_id:    workspace.entity_id,
          kind:         'administrator'
        )
      end #administrators_for

      def invited_to(workspace)
        Workspace::User::Collection.new(
          workspace_id: workspace.id, 
          entity_id:    workspace.entity_id,
          kind:         'invited'
        )
      end

      def autoinvited_to(workspace)
        Workspace::User::Collection.new(
          workspace_id: workspace.id, 
          entity_id:    workspace.entity_id,
          kind:         'autoinvited'
        )
      end #autoinvited_to

      def is_in?(workspace, user)
        collaborators_for(workspace).include?(user) ||
        administrators_for(workspace).include?(user)
      end #is_in?

      def is_administrator?(workspace, user)
        administrators_for(workspace).include?(user)
      end #is_administrator?

      def is_collaborator?(workspace, user)
        collaborators_for(workspace).include?(user)
      end #is_collaborator?

      def memberships_for(user, entity, kind)
        Membership::Collection.new(
          kind:       kind,
          user_id:    user.id,
          entity_id:  entity.id
        )
      end #memberships_for
    end # Util
  end # Workspace
end # Belinkr
