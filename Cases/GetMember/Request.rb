# encoding: utf-8
require_relative '../../Resources/User/Member'
require_relative '../../Resources/User/Enforcer'
require_relative '../../Resources/Scrapbook/Member'
require_relative '../../Resources/Scrapbook/Enforcer'
require_relative '../../Resources/Status/Member'
require_relative '../../Resources/Invitation/Member'
require_relative '../../Resources/Invitation/Enforcer'
require_relative '../../Resources/Workspace/Member'
require_relative '../../Resources/Workspace/Enforcer'

module Belinkr
  module GetMember
    class Request
      def initialize(payload, actor, actor_profile, entity, kind)
        @payload        = payload
        @actor          = actor
        @actor_profile  = actor_profile
        @entity         = entity
        @kind           = kind
      end #initialize

      def prepare
        { 
          actor:    actor,
          member:   member,
          enforcer: enforcer
        }
      end #prepare

      private

      attr_reader :payload, :actor, :actor_profile, :entity, :kind

      def member
        @resource ||= resource_module.const_get('Member')
          .new(jail.merge payload)
          .fetch
      end #member

      def enforcer
        @enforcer ||= resource_module.const_get('Enforcer').new(member)
      end #enforcer

      def resource_module
        Belinkr.const_get(kind.capitalize)
      end #resource_module

      def jail
        { id: payload.fetch("#{kind}_id"), entity_id: entity.id }
      end #jail
    end # Request
  end # GetMember
end # Belinkr

