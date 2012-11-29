# encoding: utf-8
require 'forwardable'
require_relative './Tracker/MemoryBackend'
require_relative './Tracker/RedisBackend'

module Belinkr
  module Workspace
    class Tracker
      extend Forwardable

      KINDS = %w{ invited autoinvited administrator collaborator }

      def_delegators :@backend, *MemoryBackend::INTERFACE

      def initialize(backend=RedisBackend.new)
        @backend = backend
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

      def accept(workspace, user, kind)
        unregister(workspace, user, kind)
        register(workspace, user, :collaborator)
      end #accept

      def remove(workspace, user)
        %w{ administrator collaborator}.each do |kind|
          unregister(workspace, user, kind)
        end
      end #remove

      def unlink_from_all_workspaces(user)
        KINDS.each { |kind| unlink_from_workspaces(user, kind) }
        self
      end #unlink_from_all_workspaces

      def unlink_from_all_users(workspace)
        KINDS.each { |kind| unlink_from_users(workspace, kind) }
        self
      end #unlink_from_all_users

      def relink_to_all_workspaces(user)
        KINDS.each { |kind| relink_to_workspaces(user, kind) }
        self
      end #relink_to_all_workspaces
        
      def relink_to_all_users(workspace)
        KINDS.each { |kind| relink_to_users(workspace, kind) }
        self
      end #relink_to_all_users
    end # Tracker
  end # Workspace
end # Belinkr

