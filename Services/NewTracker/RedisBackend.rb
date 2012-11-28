# encoding: utf-8
require 'redis'
require_relative '../../Resources/Workspace/Collection'
require_relative '../../Resources/User/Collection'

module Belinkr
  module Workspace
    class Tracker
      class RedisBackend
        EXPIRE_TIME = 3600 * 24 * 7

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
          delete workspaces_storage_key_for(user, kind)
        end #unlink_from_workspaces

        def unlink_from_users(workspace, kind)
          delete users_storage_key_for(workspace, kind) 
        end #unlink_from_users

        def relink_to_workspaces(user, kind)
          undelete workspaces_storage_key_for(user, kind)
        end #relink_to_workspaces

        def relink_to_users(workspace, kind)
          undelete users_storage_key_for(workspace, kind) 
        end #relink_to_users

        def users_for(workspace, kind)
          User::Collection.new(users_storage_key_for(workspace, kind))
        end #users_for

        def workspaces_for(entity, user, kind)
          Workspace::Collection.new( 
            { entity_id: entity.id },
            workspaces_storage_key_for(user, kind)
          )
        end #workspaces_for

        private 

        attr_reader :workspaces, :users

        def delete(storage_key)
          return false unless $redis.exists(storage_key)
          $redis.rename storage_key, deleted_storage_key_for(storage_key)
          $redis.expire deleted_storage_key_for(storage_key), EXPIRE_TIME
        end #delete

        def undelete(storage_key)
          return false unless $redis.exists(deleted_storage_key_for storage_key)
          $redis.rename deleted_storage_key_for(storage_key), storage_key
        end #undelete

        def users_storage_key_for(workspace, kind)
          "workspaces:#{workspace.id}:users:#{kind}"
        end #workspace_storage_key_for

        def workspaces_storage_key_for(user, kind)
          "users:#{user.id}:workspaces:#{kind}"
        end #workspace_storage_key_for

        def deleted_storage_key_for(storage_key)
          "#{storage_key}:deleted"
        end
      end # RedisBackend
    end # Tracker
  end # Workspace
end # Belinkr

