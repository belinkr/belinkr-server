# encoding: utf-8
require 'set'

module Belinkr
  module Workspace
    class Tracker
      KINDS = %w{ invited autoinvited administrators collaborators }

      def initialize
        @workspaces = {}
        @users      = {}
      end #initialize

      def register(workspace, user, kind)
        link_user_to_workspace(workspace, user, kind)
        link_workspace_to_user(workspace, user, kind)
        self
      end #register

      def unregister(workspace, user, kind)
        unlink_user_from_workspace(workspace, user, kind)
        unlink_workspace_from_user(workspace, user, kind)
        self
      end #unregister

      def users_for(workspace, kind)
        workspaces.fetch(users_storage_key_for(workspace, kind), Set.new)
      end #users_for

      def workspaces_for(user, kind)
        users.fetch(workspaces_storage_key_for(user, kind), Set.new)
      end #workspaces_for

      def unlink_from_all_workspaces(user)
        KINDS.each { |kind| unlink_from_workspaces(user, kind) }
        self
      end #unlink_from_all_workspace

      def unlink_from_all_users(workspace)
        KINDS.each { |kind| unlink_from_users(workspace, kind) }
        self
      end #unlink_from_all_users

      private

      attr_reader :workspaces, :users

      def link_user_to_workspace(workspace, user, kind)
        storage_key = workspaces_storage_key_for(user, kind)
        data        = users.fetch(storage_key, Set.new).add workspace.id
        users.store(storage_key, data)
      end #link_user_to_workspace

      def link_workspace_to_user(workspace, user, kind)
        storage_key = users_storage_key_for(workspace, kind)
        data        = workspaces.fetch(storage_key, Set.new).add user.id
        workspaces.store(storage_key, data)
      end #link_workspace_to_user

      def unlink_user_from_workspace(workspace, user, kind)
        storage_key = workspaces_storage_key_for(user, kind)
        data        = users.fetch(storage_key, Set.new).delete workspace.id
        users.store(storage_key, data)
      end #unlink_user_from_workspace

      def unlink_workspace_from_user(workspace, user, kind)
        storage_key = users_storage_key_for(workspace, kind)
        data        = workspaces.fetch(storage_key, Set.new).delete user.id
        workspaces.store(storage_key, data)
      end #unlink_workspace_from_user

      def unlink_from_workspaces(user, kind)
        storage_key = workspaces_storage_key_for(user, kind)
        data        = users.fetch(storage_key, Set.new).clear
        users.store(storage_key, data)
      end #unlink_from_workspaces

      def unlink_from_users(workspace, kind)
        storage_key = users_storage_key_for(workspace, kind)
        data        = workspaces.fetch(storage_key, Set.new).clear
        workspaces.store(storage_key, data)
      end #unlink_from_users

      def users_storage_key_for(workspace, kind)
        "workspaces:#{workspace.id}:users:#{kind}"
      end #workspace_storage_key_for

      def workspaces_storage_key_for(user, kind)
        "users:#{user.id}:workspaces:#{kind}"
      end #workspace_storage_key_for
    end # Tracker
  end # Workspace
end # Belinkr

