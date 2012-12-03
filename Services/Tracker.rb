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

      def track_collaborator(workspace, user)
        KINDS.each { |kind| untrack(workspace, user, kind) }
        track(workspace, user, :collaborator)
        track_relationship(workspace, user, :collaborator)
        self
      end #track_collaborator

      def track_administrator(workspace, user)
        KINDS.each { |kind| untrack(workspace, user, kind) }
        track(workspace, user, :administrator)
        track_relationship(workspace, user, :administrator)
        self
      end #track_administrator

      def track_invitation(workspace, user, invitation)
        track(workspace, user, :invited)
        track_relationship(workspace, user, "invitation:#{invitation.id}")
        self
      end #track_invitation

      def track_autoinvitation(workspace, user, autoinvitation)
        track(workspace, user, :autoinvited)
        track_relationship(workspace, user,
          "autoinvitation:#{autoinvitation.id}")
        self
      end #track_autoinvitation

      def untrack_invitation(workspace, user, invitation)
        untrack(workspace, user, :invited)
        untrack_relationship(workspace, user)
        self
      end #untrack_invitation

      def untrack_autoinvitation(workspace, user, autoinvitation)
        untrack(workspace, user, :autoinvited)
        untrack_relationship(workspace, user)
        self
      end #untrack_autoinvitation

      # Remove a user from this workspace, no matter he is
      # a collaborator or administrator
      def remove(workspace, user)
        untrack(workspace, user, :collaborator)
        untrack(workspace, user, :administrator)
        untrack_relationship(workspace, user)
        self
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

      def sync
      end #sync

      private

      def track(workspace, user, kind)
        link_user_to_workspace(workspace, user, kind)
        link_workspace_to_user(workspace, user, kind)
      end #track

      def untrack(workspace, user, kind)
        unlink_user_from_workspace(workspace, user, kind)
        unlink_workspace_from_user(workspace, user, kind)
      end #untrack
    end # Tracker
  end # Workspace
end # Belinkr

