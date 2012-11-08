# encoding: utf-8
require_relative '../RegisterActivity/Context'
require_relative '../../Tinto/Context'

module Belinkr
  module FollowUserInEntity
    class Context
      include Tinto::Context

      attr_writer :register_activity_context

      def initialize(options={})
        @enforcer         = options.fetch(:enforcer)
        @actor            = options.fetch(:actor)
        @followed         = options.fetch(:followed)
        @followers        = options.fetch(:followers)
        @following        = options.fetch(:following)
        @entity           = options.fetch(:entity)
        @actor_timeline   = options.fetch(:actor_timeline)
        @latest_statuses  = options.fetch(:latest_statuses)
      end

      def call
        enforcer.authorize(actor, :follow)
        followers.add actor
        following.add followed
        actor_timeline.merge latest_statuses

        register_activity_context.call

        will_sync followers, following, actor_timeline, 
                  register_activity_context
      end #call

      def register_activity_context
        @register_activity_context || RegisterActivity::Context.new(
          actor:  actor,
          action: 'follow', 
          object: followed,
          entity: entity
        )
      end #register_activity_context

      private

      attr_reader :enforcer, :actor, :followed, :followers, :following,
                  :entity, :actor_timeline, :latest_statuses
    end # Context
  end # FollowUserInEntity
end # Belinkr

