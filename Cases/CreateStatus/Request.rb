# encoding: utf-8
require_relative '../../Resources/Status/Member'
require_relative '../../Resources/Workspace/Scope'
require_relative '../../Resources/Scrapbook/Scope'
require_relative '../../Resources/User/Scope'

module Belinkr
  module CreateStatus
    class Request
      def initialize(payload, actor, profile, entity)
        @payload    = payload
        @actor      = actor
        @profile    = profile
        @entity     = entity
      end #initialize

      def prepare
        {
          enforcer:   scope.enforcer,
          actor:      actor,
          status:     status,
          timelines:  scope.timelines,
        }
      end #prepare

      private

      attr_reader :payload, :actor, :profile, :entity

      def status
        Status::Member.new(payload.merge jail)
      end #status

      def jail
        { author: actor }
      end #jail

      def scope
        return workspace_scope if payload.include?('workspace_id')
        return scrapbook_scope if payload.include?('scrapbook_id')
        return user_scope
      end #scope

      def workspace_scope
        Workspace::Scope.new(payload, status, entity)
      end #workspace_scope

      def scrapbook_scope
        Scrapbook::Scope.new(payload, status, actor)
      end #scrapbook_scope

      def user_scope
        User::Scope.new(payload, status, actor, entity)
      end #user_scope
    end # Request
  end # CreateStatus
end # Belinkr

