# encoding: utf-8
require_relative '../RegisterActivity/Context'
require 'Tinto/Context'

module Belinkr
  module UnfollowUserInEntity
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
      end #initialize

      def call
        enforcer          .authorize(actor, :unfollow)
        followers         .delete(actor)
        following         .delete(followed)

        actor_profile     .decrement_following_counter
        followed_profile  .decrement_followers_counter

        register_activity_context.call

        will_sync followers, following, actor_profile, 
                  followed_profile, register_activity_context
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
                  :followed_profile, :followers, :following, :entity
    end # Context
  end # FollowUserInEntity
end # Belinkr
