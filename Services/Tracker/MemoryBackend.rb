# encoding: utf-8
require 'set'
require_relative '../../Resources/Workspace/Member'
require_relative '../../Resources/User/Member'

module Belinkr
  module Workspace
    class Tracker
      class MemoryBackend
        INTERFACE = %w{
          link_user_to_workspace
          link_workspace_to_user
          unlink_user_from_workspace
          unlink_workspace_from_user
          unlink_from_workspaces
          unlink_from_users
          relink_to_workspaces
          relink_to_users
          users_for
          workspaces_for
          is?
        }

        def initialize
          @workspaces = {}
          @users      = {}
        end

        def link_user_to_workspace(workspace, user, kind)
          key   = users_key_for(workspace, kind)
          data  = workspaces.fetch(key, Set.new).add user.id.to_s
          workspaces.store(key, data)
        end #link_user_to_workspace

        def link_workspace_to_user(workspace, user, kind)
          key   = workspaces_key_for(user, kind)
          data  = users.fetch(key, Set.new).add workspace.id.to_s
          users.store(key, data)
        end #link_workspace_to_user

        def unlink_user_from_workspace(workspace, user, kind)
          key   = users_key_for(workspace, kind)
          data  = workspaces.fetch(key, Set.new).delete user.id.to_s
          workspaces.store(key, data)
        end #unlink_user_from_workspace

        def unlink_workspace_from_user(workspace, user, kind)
          key   = workspaces_key_for(user, kind)
          data  = users.fetch(key, Set.new).delete workspace.id.to_s
          users.store(key, data)
        end #unlink_workspace_from_user

        def unlink_from_workspaces(user, kind)
          workspace_ids = users.fetch(workspaces_key_for(user, kind), Set.new)
          workspace_ids.each do |workspace_id|
            workspace = Struct.new(:id).new(workspace_id)
            unlink_user_from_workspace(workspace, user, kind)
          end
        end #unlink_from_workspaces

        def unlink_from_users(workspace, kind)
          user_ids = workspaces.fetch(users_key_for(workspace, kind), Set.new)
          user_ids.each do |user_id|
            user = Struct.new(:id).new(user_id)
            unlink_workspace_from_user(workspace, user, kind)
          end
        end #unlink_from_users

        def relink_to_workspaces(user, kind)
          workspace_ids = users.fetch(workspaces_key_for(user, kind), Set.new)
          workspace_ids.each do |workspace_id|
            workspace = Struct.new(:id).new(workspace_id)
            link_user_to_workspace(workspace, user, kind)
          end
        end #relink_to_workspaces

        def relink_to_users(workspace, kind)
          user_ids = workspaces.fetch(users_key_for(workspace, kind), Set.new)
          user_ids.each do |user_id|
            user = Struct.new(:id).new(user_id)
            link_workspace_to_user(workspace, user, kind)
          end
        end #relink_to_users

        def users_for(workspace, kind)
          users = AugmentedSet.new user_members_for(workspace, kind)
        end #users_for

        def workspaces_for(entity, user, kind)
          workspaces = AugmentedSet.new workspace_members_for(entity, user, kind)
        end #workspaces_for

        def is?(workspace, user, kind)
          user_ids = workspaces.fetch(users_key_for(workspace, kind), [])
          user_ids.include?(user.id.to_s)
        end #is?

        private 

        attr_reader :workspaces, :users

        def workspace_members_for(entity, user, kind)
          ids = users.fetch(workspaces_key_for(user, kind), [])
          ids.map { |id| Workspace::Member.new(id: id, entity_id: entity.id) }
        end #workspace_members_for

        def user_members_for(workspace, kind)
          ids = workspaces.fetch(users_key_for(workspace, kind), [])
          ids.map { |id| User::Member.new(id: id) }
        end #user_members_for

        def users_key_for(workspace, kind)
          "workspaces:#{workspace.id.to_s}:users:#{kind}"
        end #workspace_key_for

        def workspaces_key_for(user, kind)
          "users:#{user.id.to_s}:workspaces:#{kind}"
        end #workspace_key_for

        class AugmentedSet
          def initialize(members=[])
            @set = Set.new members
          end #initialize

          def include?(other)
            @set.map(&:id).include?(other.id.to_s)
          end #include?

          def empty?
            @set.empty?
          end
        end #AugmentedSet
      end # MemoryBackend
    end # Tracker
  end # Workspace
end # Belinkr

