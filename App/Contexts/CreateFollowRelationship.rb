# encoding: utf-8
require_relative '../Follower/Collection'
require_relative '../Following/Collection'
 
module Belinkr
  class CreateFollowRelationship
    def initialize(options={})
      @actor      = options.fetch(:actor)
      @followed   = options.fetch(:followed)
      @followers  = options.fetch(:followers)
      @following  = options.fetch(:following)
    end

    def call
      $redis.multi do
        @followers.add @actor
        @following.add @followed
      end
    end
  end # CreateFollowRelationship
end # Belinkr

