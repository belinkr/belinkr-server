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
      def initialize(arguments)
        @payload = arguments.fetch(:payload)
        @actor   = arguments.fetch(:actor)
        @entity  = arguments.fetch(:entity)
        @type    = arguments.fetch(:type)
      end #initialize

      def prepare
        { 
          actor:      actor,
          collection: collection,
          enforcer:   enforcer
        }
      end #prepare

      private

      attr_reader :payload, :actor, :entity, :type

      def collection
        @resource ||= resource_module.const_get('Collection')
          .new(defaults.merge payload)
          .page(payload.fetch('page', 0))
      end #collection

      def enforcer
        @enforcer ||= resource_module.const_get('Enforcer').new(collection)
      end #enforcer

      def resource_module
        Belinkr.const_get(type.capitalize)
      end #resource_module

      def defaults
        @defaults ||= { entity_id: entity.id, user_id: actor.id, kind: 'own' }
      end #defaults
    end # Request
  end # GetCollection
end # Belinkr

