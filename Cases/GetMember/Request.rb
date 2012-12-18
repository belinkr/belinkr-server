# encoding: utf-8
require_relative '../../Resources/User/Member'
require_relative '../../Resources/User/Enforcer'
require_relative '../../Resources/Scrapbook/Member'
require_relative '../../Resources/Scrapbook/Enforcer'
require_relative '../../Resources/Status/Member'
require_relative '../../Resources/Reset/Member'
require_relative '../../Resources/Invitation/Member'
require_relative '../../Resources/Invitation/Enforcer'
require_relative '../../Resources/Workspace/Member'
require_relative '../../Resources/Workspace/Enforcer'

module Belinkr
  module GetMember
    class Request
      def initialize(arguments)
        @payload  = arguments.fetch(:payload)
        @actor    = arguments.fetch(:actor)
        @entity   = arguments.fetch(:entity)
        @type     = arguments.fetch(:type)
      end #initialize

      def prepare
        { 
          actor:    actor,
          member:   member,
          enforcer: enforcer
        }
      end #prepare

      private

      attr_reader :payload, :actor, :entity, :type

      def member
        @member ||= resource_module.const_get('Member')
          .new(defaults.merge payload)
          .fetch
      end #member

      def enforcer
        @enforcer ||= resource_module.const_get('Enforcer').new(member)
      end #enforcer

      def resource_module
        Belinkr.const_get(type.capitalize)
      end #resource_module

      def defaults
        @defaults ||= { 
          id:         payload.fetch("#{type}_id"), 
          entity_id:  entity.id,
          user_id:    actor.id
        }
      end #defaults
    end # Request
  end # GetMember
end # Belinkr

