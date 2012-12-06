# encoding: utf-8
require_relative './Enforcer'
require_relative '../Follower/Collection'
require_relative '../../Services/Timeliner'

module Belinkr
  module User
    class Scope
      RESOURCE_TIMELINES  = %w{ own general files }
      MEMBER_TIMELINES    = %w{ general files }

      def initialize(payload, status, actor, entity)
        @payload    = payload
        @status     = status
        @actor      = actor
        @entity     = entity
        @timeliner  = Timeliner.new(status)
      end #initialize

      def resource
        actor
      end

      def enforcer
        User::Enforcer.new(resource)
      end

      def timelines
        timeliner.resource_timelines_for(resource, RESOURCE_TIMELINES ) +
        timeliner.member_timelines_for(members, MEMBER_TIMELINES)
      end #timelines

      def members
        Follower::Collection.new(
          user_id:    actor.id,
          entity_id:  entity.id
        )
      end #members

      private

      attr_reader :payload, :status, :entity, :actor, :timeliner
    end # Scope
  end # User
end # Belinkr

