# encoding: utf-8
require 'set'

module Belinkr
  module Workspace
    class Tracker
      class MemoryBackend
        INTERFACE = %w{
          link_user_to_workspace link_workspace_to_user
          unlink_user_from_workspace unlink_workspace_from_user
          unlink_from_workspaces unlink_from_users
          users_for workspaces_for
        }

        def initialize
          @workspaces = {}
          @users      = {}
        end

        def link_user_to_workspace(workspace, user, kind)
          storage_key = workspaces_storage_key_for(user, kind)
          data        = users.fetch(storage_key, Set.new).add workspace.id.to_s
          users.store(storage_key, data)
        end #link_user_to_workspace

        def link_workspace_to_user(workspace, user, kind)
          storage_key = users_storage_key_for(workspace, kind)
          data        = workspaces.fetch(storage_key, Set.new).add user.id.to_s
          workspaces.store(storage_key, data)
        end #link_workspace_to_user

        def unlink_user_from_workspace(workspace, user, kind)
          storage_key = workspaces_storage_key_for(user, kind)
          data        = users.fetch(storage_key, Set.new).delete workspace.id.to_s
          users.store(storage_key, data)
        end #unlink_user_from_workspace

        def unlink_workspace_from_user(workspace, user, kind)
          storage_key = users_storage_key_for(workspace, kind)
          data        = workspaces.fetch(storage_key, Set.new).delete user.id.to_s
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

        def users_for(workspace, kind)
          workspaces.fetch(users_storage_key_for(workspace, kind), Set.new)
        end #users_for

        def workspaces_for(user, kind)
          users.fetch(workspaces_storage_key_for(user, kind), Set.new)
        end #workspaces_for

        private 

        attr_reader :workspaces, :users

        def users_storage_key_for(workspace, kind)
          "workspaces:#{workspace.id.to_s}:users:#{kind}"
        end #workspace_storage_key_for

        def workspaces_storage_key_for(user, kind)
          "users:#{user.id.to_s}:workspaces:#{kind}"
        end #workspace_storage_key_for
      end # MemoryBackend
    end # Tracker
  end # Workspace
end # Belinkr
