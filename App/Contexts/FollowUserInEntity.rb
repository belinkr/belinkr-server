# encoding: utf-8
require_relative './RegisterActivity'
require_relative '../../Tinto/Context'
require_relative '../../Tinto/Exceptions'

module Belinkr
  class FollowUserInEntity
    include Tinto::Context

    def initialize(options={})
      @actor            = options.fetch(:actor)
      @followed         = options.fetch(:followed)
      @followers        = options.fetch(:followers)
      @following        = options.fetch(:following)
      @entity           = options.fetch(:entity)
      @actor_timeline   = options.fetch(:actor_timeline)
      @latest_statuses  = options.fetch(:latest_statuses)
      @activity_context = options.fetch(:activity_context) || RegisterActivity

      will_sync followers, following, timeline, activity_context
    end

    def call
      raise InvalidMember if actor.id == followed.id
      followers.add actor
      following.add followed
      actor_timeline.merge latest_statuses

      activity_context.new(
        actor:  actor,
        action: 'follow', 
        object: followed,
        entity: entity
      ).call
    end #call
  end # FollowUserInEntity
end # Belinkr

