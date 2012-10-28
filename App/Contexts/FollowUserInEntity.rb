# encoding: utf-8
require_relative './RegisterActivity'
require_relative '../../Tinto/Context'
require_relative '../../Tinto/Exceptions'

module Belinkr
  class FollowUserInEntity
    include Tinto::Context
    include Tinto::Exceptions

    def initialize(options={})
      @actor            = options.fetch(:actor)
      @followed         = options.fetch(:followed)
      @followers        = options.fetch(:followers)
      @following        = options.fetch(:following)
      @entity           = options.fetch(:entity)
      @actor_timeline   = options.fetch(:actor_timeline)
      @latest_statuses  = options.fetch(:latest_statuses)
    end

    def call
      raise InvalidMember if @actor.id == @followed.id
      @followers.add @actor
      @following.add @followed
      @actor_timeline.merge @latest_statuses

      @activity_context = RegisterActivity.new(
        actor:  @actor,
        action: 'follow', 
        object: @followed,
        entity: @entity
      )
      @activity_context.call

      @to_sync = [@followers, @following, @actor_timeline, @activity_context]
      @followed
    end
  end # FollowUserInEntity
end # Belinkr

