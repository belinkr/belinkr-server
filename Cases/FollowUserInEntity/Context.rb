# encoding: utf-8
require_relative '../RegisterActivity/Context'
require 'Tinto/Context'

module Belinkr
  module FollowUserInEntity
    class Context
      include Tinto::Context

      attr_writer :register_activity_context

      def initialize(options={})
        @enforcer         = options.fetch(:enforcer)
        @actor            = options.fetch(:actor)
        @actor_profile    = options.fetch(:actor_profile)
        @followed         = options.fetch(:followed)
        @followed_profile = options.fetch(:followed_profile)
        @followers        = options.fetch(:followers)
        @following        = options.fetch(:following)
        @entity           = options.fetch(:entity)
        @actor_timeline   = options.fetch(:actor_timeline)
        @latest_statuses  = options.fetch(:latest_statuses)
      end

      def call
        enforcer          .authorize(actor, :follow)
        followers         .add(actor)
        following         .add(followed)
        actor_profile     .increment_following_counter
        followed_profile  .increment_followers_counter
        actor_timeline    .merge(latest_statuses)

        will_sync followers, following, actor_profile, followed_profile, 
                  actor_timeline
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

      attr_reader :enforcer, :actor, :actor_profile, :followed, 
                  :followed_profile, :followers, :following,
                  :entity, :actor_timeline, :latest_statuses
    end # Context
  end # FollowUserInEntity
end # Belinkr

