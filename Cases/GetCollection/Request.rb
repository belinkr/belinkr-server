# encoding: utf-8
require_relative '../../Resources/User/Collection'
require_relative '../../Resources/User/Enforcer'
require_relative '../../Resources/Scrapbook/Collection'
require_relative '../../Resources/Scrapbook/Enforcer'
require_relative '../../Resources/Status/Collection'
require_relative '../../Resources/Invitation/Collection'
require_relative '../../Resources/Invitation/Enforcer'
require_relative '../../Resources/Workspace/Collection'
require_relative '../../Resources/Workspace/Enforcer'

module Belinkr
  module GetCollection
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
          actor:      actor,
          collection: collection,
          enforcer:   enforcer
        }
      end #prepare

      private

      attr_reader :payload, :actor, :actor_profile, :entity, :kind

      def collection
        @resource ||= resource_module.const_get('Collection')
          .new(jail.merge payload)
          .fetch
      end #collection

      def enforcer
        @enforcer ||= resource_module.const_get('Enforcer').new(collection)
      end #enforcer

      def resource_module
        Belinkr.const_get(kind.capitalize)
      end #resource_module

      def jail
        { entity_id: entity.id }
      end #jail
    end # Request
  end # GetCollection
end # Belinkr

