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
        @kind     = arguments.fetch(:kind)
      end #initialize

      def prepare
        { 
          actor:    actor,
          member:   member,
          enforcer: enforcer
        }
      end #prepare

      private

      attr_reader :payload, :actor, :entity, :kind

      def member
        @member ||= resource_module.const_get('Member')
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
        @jail = { id: payload.fetch("#{kind}_id") }
        @jail.merge!(entity_id: entity.id)  if entity
        @jail.merge!(user_id: actor.id)     if kind =~ /scrapbook/
        @jail
      end #jail
    end # Request
  end # GetMember
end # Belinkr

