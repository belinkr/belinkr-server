# encoding: utf-8
require 'minitest/autorun'
require_relative '../../App/Contexts/UnfollowUserInEntity'
require_relative '../../App/Contexts/FollowUserInEntity'
require_relative '../Factories/Entity'
require_relative '../Factories/Profile'
require_relative '../Factories/Status'
require_relative '../../App/Follower/Collection'
require_relative '../../App/Following/Collection'
require_relative '../../App/Status/Collection'
require_relative '../../Tinto/Exceptions'

include Belinkr

describe 'unfollow user in entity' do
  before do
    @entity     = Factory.entity
    @actor      = Factory.profile(entity_id: @entity.id)
    @followed   = Factory.profile(entity_id: @entity.id)
    @following  = Following::Collection.new(
                    entity_id: @entity.id, profile_id: @actor.id
                  ).reset
    @followers  = Follower::Collection.new(
                    entity_id: @entity.id, profile_id: @actor.id
                  ).reset
    @actor_timeline = Status::Collection.new(kind: 'general', context: @actor)
    @actor_timeline.reset

    statuses = (1..20).map { 
      Factory.status(user_id: @followed.id, entity_id: @entity.id) 
    }
    @latest_statuses = Status::Collection.new(kind: 'own', context: @followed)
    @latest_statuses.reset(statuses)
    @options = {
      actor:            @actor,
      followed:         @followed,
      followers:        @followers,
      following:        @following,
      entity:           @entity,
      actor_timeline:   @actor_timeline,
      latest_statuses:  @latest_statuses
    }
    FollowUserInEntity.new(@options).call
  end

  it 'removes the followed user 
  from the following collection of the follower' do
    @following.must_include @followed
    UnfollowUserInEntity.new(@options).call
    @following.wont_include @followed
  end

  it 'removes the follower user 
  from the followers collection of the followed' do
    @followers.must_include @actor
    UnfollowUserInEntity.new(@options).call
    @followers.wont_include @actor
  end

  it 'raises if the actor and followed are the same' do
    actor             = @options.fetch(:actor)
    actor.id          = @options.fetch(:followed).id
    @options[:actor]  = actor

    lambda { UnfollowUserInEntity.new(@options).call }
      .must_raise Tinto::Exceptions::InvalidMember
  end
end # unfollow user in entity
