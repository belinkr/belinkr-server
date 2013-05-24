# encoding: utf-8
require_relative '../Workspace/Enforcer'
require_relative '../Workspace/Member'
require_relative '../Scrapbook/Enforcer'
require_relative '../Scrapbook/Member'
require_relative '../User/Enforcer'
require_relative '../User/Member'
require_relative '../Follower/Collection'
require_relative '../../Services/Tracker'

module Belinkr
  module Status
    class Scope
      RESOURCE_TIMELINES = {
        workspace:  %w{ general files },
        scrapbook:  %w{ general files },
        user:       %w{ own general files }
      }

      FOLLOWER_TIMELINES = {
        workspace: %w{ workspaces files },
        scrapbook: [],
        user:      %w{ general files }
      }

      def initialize(payload, user, entity)
        @payload  = payload
        @user     = user
        @entity   = entity
      end #initialize

      def enforcer
        resource_module.const_get('Enforcer').new resource
      end #enforcer

      def resource
        @resource ||= send kind_from(payload)
      end # resource

      def followers
        send :"#{kind_from(payload)}_followers"
      end #followers

      def resource_timelines
        RESOURCE_TIMELINES.fetch kind_from(payload)
      end #resource_timelines

      def follower_timelines
        FOLLOWER_TIMELINES.fetch kind_from(payload)
      end #follower_timelines

      private

      attr_reader :payload, :user, :entity

      def resource_module
        Belinkr.const_get kind_from(payload).capitalize
      end

      def kind_from(payload)
        return :workspace if payload.include?('workspace_id')
        return :scrapbook if payload.include?('scrapbook_id')
        return :user
      end #kind_from

      def workspace
        Workspace::Member.new(
          id:         payload.fetch('workspace_id'),
          entity_id:  entity.id
        )
      end #workspace

      def scrapbook
        Scrapbook::Member.new(
          id:       payload.fetch('scrapbook_id'),
          user_id:  user.id
        )
      end #scrapbook

      def workspace_followers
        Workspace::Tracker.new.users_for(resource, :member)
      end #workspace_followers

      def user_followers
        Follower::Collection.new(
          user_id:    user.id,
          entity_id:  entity.id
        )
      end #user_followers

      def scrapbook_followers
        []
      end #scrapbook_followers

    end # Scope
  end # Status
end # Belinkr

