# encoding: utf-8
require 'minitest/autorun'
require 'redis'
require_relative '../../App/Contexts/FollowUserInEntity'
require_relative '../Factories/Entity'
require_relative '../Factories/Profile'
require_relative '../Factories/Status'
require_relative '../../App/Follower/Collection'
require_relative '../../App/Following/Collection'
require_relative '../../App/Status/Collection'
require_relative '../../Tinto/Exceptions'

include Belinkr

$redis ||= Redis.new
$redis.select 8

describe 'create follow relationship' do
  before do
    $redis.flushdb
    @entity     = Factory.entity
    @actor      = Factory.profile(entity_id: @entity.id)
    @followed   = Factory.profile(entity_id: @entity.id)
    @following  = Following::Collection.new(
                    entity_id: @entity.id, user_id: @actor.user_id
                  ).reset
    @followers  = Follower::Collection.new(
                    entity_id: @entity.id, user_id: @actor.user_id
                  ).reset
    @actor_timeline = Status::Collection.new(kind: 'general', context: @actor)
    @actor_timeline.reset

    statuses = (1..40).map { 
      Factory.status(user_id: @followed.id, entity_id: @entity.id) 
    }
    @latest_statuses = Status::Collection.new(kind: 'own', context: @followed)
    @latest_statuses.reset(statuses).sync.page
    @options = {
      actor:            @actor,
      followed:         @followed,
      followers:        @followers,
      following:        @following,
      entity:           @entity,
      actor_timeline:   @actor_timeline,
      latest_statuses:  @latest_statuses
    }
  end

  it 'adds the followed user to the following collection of the follower' do
    @following.wont_include @followed
    FollowUserInEntity.new(@options).call
    @following.must_include @followed
  end

  it 'adds the follower user to the followers collection of the followed' do
    @followers.wont_include @actor
    FollowUserInEntity.new(@options).call
    @followers.must_include @actor
  end

  it 'adds a the latest page of statuses from the followed to the
    timeline of the follower' do
    @latest_statuses.each { |status| @actor_timeline.wont_include status }
    FollowUserInEntity.new(@options).call
    @latest_statuses.each { |status| @actor_timeline.must_include status }

    @actor_timeline.length.must_equal 20
  end

  it 'raises if the actor and followed are the same' do
    actor             = @options.fetch(:actor)
    actor.id          = @options.fetch(:followed).id
    @options[:actor]  = actor

    lambda { FollowUserInEntity.new(@options).call }
      .must_raise Tinto::Exceptions::InvalidMember
  end
end
