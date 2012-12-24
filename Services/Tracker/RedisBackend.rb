# encoding: utf-8
require 'redis'
require 'Tinto/Exceptions'
require_relative '../../Resources/Workspace/Collection'
require_relative '../../Resources/Workspace/Invitation/Member'
require_relative '../../Resources/Workspace/Autoinvitation/Member'
require_relative '../../Resources/User/Collection'

module Belinkr
  module Workspace
    class Tracker
      class RedisBackend
        include Tinto::Exceptions

        def link_user_to_workspace(workspace, user, kind)
          $redis.sadd users_key_for(workspace, kind), user.id
        end #link_user_to_workspace

        def link_workspace_to_user(workspace, user, kind)
          $redis.sadd workspaces_key_for(user, kind), workspace.id
        end #link_workspace_to_user

        def unlink_user_from_workspace(workspace, user, kind)
          $redis.srem users_key_for(workspace, kind), user.id
        end #unlink_user_from_workspace

        def unlink_workspace_from_user(workspace, user, kind)
          $redis.srem workspaces_key_for(user, kind), workspace.id
        end #unlink_workspace_from_user

        def unlink_from_workspaces(user, kind)
          workspace_ids = $redis.smembers workspaces_key_for(user, kind)
          $redis.multi do
            workspace_ids.each do |workspace_id|
              workspace = Struct.new(:id).new(workspace_id)
              unlink_user_from_workspace(workspace, user, kind)
            end
          end
        end #unlink_from_workspaces

        def unlink_from_users(workspace, kind)
          user_ids = $redis.smembers users_key_for(workspace, kind) 
          $redis.multi do
            user_ids.each do |user_id|
              user = Struct.new(:id).new(user_id)
              unlink_workspace_from_user(workspace, user, kind)
            end
          end
        end #unlink_from_users

        def relink_to_workspaces(user, kind)
          workspace_ids = $redis.smembers workspaces_key_for(user, kind)
          $redis.multi do
            workspace_ids.each do |workspace_id|
              workspace = Struct.new(:id).new(workspace_id)
              link_user_to_workspace(workspace, user, kind)
            end
          end
        end #relink_to_workspaces

        def relink_to_users(workspace, kind)
          user_ids = $redis.smembers users_key_for(workspace, kind) 
          $redis.multi do
            user_ids.each do |user_id|
              user = Struct.new(:id).new(user_id)
              link_workspace_to_user(workspace, user, kind)
            end
          end
        end #relink_to_users

        def users_for(workspace, kind)
          User::Collection.new(users_key_for(workspace, kind))
        end #users_for

        def workspaces_for(entity, user, kind)
          Workspace::Collection
            .new({ entity_id: entity.id }, workspaces_key_for(user, kind))
        end #workspaces_for

        def autoinvitation_for(workspace, user)
          Workspace::Autoinvitation::Member.new(
            id:           autoinvitation_id_for(workspace, user),
            workspace_id: workspace.id,
            entity_id:    workspace.entity_id
          )
        end #autoinvitation_for

        def relationship_for(workspace, user)
          $redis.get relationship_key_for(workspace, user)
        end #relationship_for

        def invitation_for(workspace, user)
          Workspace::Invitation::Member.new(
            id:           invitation_id_for(workspace, user),
            workspace_id: workspace.id,
            entity_id:    workspace.entity_id
          )
        end #invitation_for

        private

        def track_relationship(workspace, user, relationship)
          $redis.set relationship_key_for(workspace, user), relationship
        end #track_relationship

        def untrack_relationship(workspace, user)
          $redis.del relationship_key_for(workspace, user)
        end #untrack_relationship

        def invitation_id_for(workspace, user)
          relationship      = relationship_for(workspace, user)
          relationship, id  = relationship.split(':') if relationship
          raise InvalidResource unless relationship == 'invitation'
          id
        end #invitation_id_for

        def autoinvitation_id_for(workspace, user)
          relationship      = relationship_for(workspace, user)
          relationship, id  = relationship.split(':') if relationship
          raise InvalidResource unless relationship == 'autoinvitation'
          id
        end #autoinvitation_id_for
        
        def relationship_key_for(workspace, user)
          "users:#{user.id}:workspaces:#{workspace.id}:relationship"
        end #autoinvitation_id_key_for

        def users_key_for(workspace, kind)
          "workspaces:#{workspace.id}:users:#{kind}"
        end #workspace_key_for

        def workspaces_key_for(user, kind)
          "users:#{user.id}:workspaces:#{kind}"
        end #workspace_key_for
      end # RedisBackend
    end # Tracker
  end # Workspace
end # Belinkr

