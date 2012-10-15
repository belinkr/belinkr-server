# encoding: utf-8
require_relative './CreateFollowRelationship'
require_relative './PopulateWithLatestStatuses'
require_relative './RegisterActivity'

module Belinkr
  class FollowUserInEntity
    def initialize(options={})
      @actor      = options.fetch(:actor)
      @followed   = followed
      @followers  = options.fetch(:followers)
      @following  = options.fetch(:following)
      @followed   = options.fetch(:followed)
      @entity     = options.fetch(:entity)
    end

    def call
      CreateFollowRelationship.new(options).call
      PopulateWithLatestStatuses.new(options).call
      RegisterActivity.new(
        actor:  @actor,
        action: 'follow', 
        object: @followed,
        entity: @entity
      ).call

      @followed
    end

    private

    def latest_statuses_from(user)
      @timeline.new(
        user_id:    user.id
        entity_id:  @entity.id
        kind:       'own'
      ).page(0).to_a
    end
  end # FollowUserInEntity
end # Belinkr
