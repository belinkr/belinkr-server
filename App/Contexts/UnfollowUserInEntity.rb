# encoding: utf-8
require_relative './RegisterActivity'
require_relative '../../Tinto/Context'
require_relative '../../Tinto/Exceptions'

module Belinkr
  class UnfollowUserInEntity
    include Tinto::Context

    def initialize(options={})
      @actor            = options.fetch(:actor)
      @followed         = options.fetch(:followed)
      @followers        = options.fetch(:followers)
      @following        = options.fetch(:following)
      @entity           = options.fetch(:entity)
    end

    def call
      raise Tinto::Exceptions::InvalidMember if @actor.id == @followed.id
      @followers.delete @actor
      @following.delete @followed

      @activity_context = RegisterActivity.new(
        actor:  @actor,
        action: 'follow', 
        object: @followed,
        entity: @entity
      )
      @activity_context.call

      @to_sync = [@followers, @following, @activity_context]
      @followed
    end
  end # FollowUserInEntity
end # Belinkr
