# encoding: utf-8
require 'redis'
require_relative '../../Resources/Workspace/Collection'
require_relative '../../Resources/User/Collection'

module Belinkr
  module Workspace
    class Tracker
      class RedisBackend
        def link_user_to_workspace(workspace, user, kind)
          $redis.sadd users_storage_key_for(workspace, kind), user.id
        end #link_user_to_workspace

        def link_workspace_to_user(workspace, user, kind)
          $redis.sadd workspaces_storage_key_for(user, kind), workspace.id
        end #link_workspace_to_user

        def unlink_user_from_workspace(workspace, user, kind)
          $redis.srem users_storage_key_for(workspace, kind), user.id
        end #unlink_user_from_workspace

        def unlink_workspace_from_user(workspace, user, kind)
          $redis.srem workspaces_storage_key_for(user, kind), workspace.id
        end #unlink_workspace_from_user

        def unlink_from_workspaces(user, kind)
          workspace_ids = $redis.smembers workspaces_storage_key_for(user, kind)
          $redis.multi do
            workspace_ids.each do |workspace_id|
              workspace = Struct.new(:id).new(workspace_id)
              unlink_user_from_workspace(workspace, user, kind)
            end
          end
        end #unlink_from_workspaces

        def unlink_from_users(workspace, kind)
          user_ids = $redis.smembers users_storage_key_for(workspace, kind) 
          $redis.multi do
            user_ids.each do |user_id|
              user = Struct.new(:id).new(user_id)
              unlink_workspace_from_user(workspace, user, kind)
            end
          end
        end #unlink_from_users

        def relink_to_workspaces(user, kind)
          workspace_ids = $redis.smembers workspaces_storage_key_for(user, kind)
          $redis.multi do
            workspace_ids.each do |workspace_id|
              workspace = Struct.new(:id).new(workspace_id)
              link_user_to_workspace(workspace, user, kind)
            end
          end
        end #relink_to_workspaces

        def relink_to_users(workspace, kind)
          user_ids = $redis.smembers users_storage_key_for(workspace, kind) 
          $redis.multi do
            user_ids.each do |user_id|
              user = Struct.new(:id).new(user_id)
              link_workspace_to_user(workspace, user, kind)
            end
          end
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

