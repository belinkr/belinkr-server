# encoding: utf-8
require 'redis'

module Belinkr
  module Workspace
    class Tracker
      class RedisBackend
        def link_user_to_workspace(workspace, user, kind)
          $redis.sadd workspaces_storage_key_for(user, kind), workspace.id
        end #link_user_to_workspace

        def link_workspace_to_user(workspace, user, kind)
          $redis.sadd users_storage_key_for(workspace, kind), user.id
        end #link_workspace_to_user

        def unlink_user_from_workspace(workspace, user, kind)
          $redis.srem workspaces_storage_key_for(user, kind), workspace.id
        end #unlink_user_from_workspace

        def unlink_workspace_from_user(workspace, user, kind)
          $redis.srem users_storage_key_for(workspace, kind), user.id
        end #unlink_workspace_from_user

        def unlink_from_workspaces(user, kind)
          $redis.del workspaces_storage_key_for(user, kind)
        end #unlink_from_workspaces

        def unlink_from_users(workspace, kind)
          $redis.del users_storage_key_for(workspace, kind) 
        end #unlink_from_users

        def users_for(workspace, kind)
          Set.new $redis.smembers(users_storage_key_for(workspace, kind))
        end #users_for

        def workspaces_for(user, kind)
          Set.new $redis.smembers(workspaces_storage_key_for(user, kind))
        end #workspaces_for

        private 

        attr_reader :workspaces, :users

        def users_storage_key_for(workspace, kind)
          "workspaces:#{workspace.id}:users:#{kind}"
        end #workspace_storage_key_for

        def workspaces_storage_key_for(user, kind)
          "users:#{user.id}:workspaces:#{kind}"
        end #workspace_storage_key_for
      end # RedisBackend
    end # Tracker
  end # Workspace
end # Belinkr
