# encoding: utf-8
require_relative '../Workspace/Enforcer'
require_relative '../Workspace/Member'
require_relative '../Scrapbook/Enforcer'
require_relative '../Scrapbook/Member'
require_relative '../User/Enforcer'
require_relative '../User/Member'
module Belinkr
  module Status
    class Scope
      def initialize(payload, actor, entity)
        @payload  = payload
        @actor    = actor
        @entity   = entity
      end #initialize

      def enforcer
        @enforcer ||= enforcer_klass.new(resource)
      end #enforcer

      def resource
        @resource ||= send resource_method
      end # resource

      private

      attr_reader :payload, :actor, :entity

      def resource_method
        {
          workspace:  :workspace,
          scrapbook:  :scrapbook,
          user:       :actor
        }.fetch kind_from(payload)
      end #resource_method

      def enforcer_klass
        {
          workspace: Workspace::Enforcer,
          scrapbook: Scrapbook::Enforcer,
          user:      User::Enforcer
        }.fetch kind_from(payload)
      end #enforcer_klass

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
          user_id:  actor.id
        )
      end #scrapbook
    end # Scope
  end # Status
end # Belinkr

