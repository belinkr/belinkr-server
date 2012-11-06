# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../App/Contexts/FollowUserInEntity'
require_relative '../Doubles/Enforcer/Double'
require_relative '../Doubles/Collection/Double'

include Belinkr

describe 'follow user in entity' do
  before do
    @enforcer         = Enforcer::Double.new
    @actor            = OpenStruct.new
    @followed         = OpenStruct.new
    @followers        = Collection::Double.new
    @following        = Collection::Double.new
    @entity           = OpenStruct.new
    @actor_timeline   = Collection::Double.new
    @latest_statuses  = Collection::Double.new
  end

  it 'authorizes the user' do
    enforcer  = Minitest::Mock.new
    context   = FollowUserInEntity.new(
      enforcer:         enforcer,
      actor:            @actor,
      followed:         @followed,
      followers:        @followers,
      following:        @following,
      entity:           @entity,
      actor_timeline:   @actor_timeline,
      latest_statuses:  @latest_statuses
    )

    enforcer.expect :authorize, true, [@actor, :follow]
    context.call
    enforcer.verify
  end

  it 'adds the followed user to the following collection of the follower' do
    following = Minitest::Mock.new
    context   = FollowUserInEntity.new(
      enforcer:         @enforcer,
      actor:            @actor,
      followed:         @followed,
      followers:        @followers,
      following:        following,
      entity:           @entity,
      actor_timeline:   @actor_timeline,
      latest_statuses:  @latest_statuses
    )

    following.expect :add, following, [@followed]
    context.call
    following.verify
  end

  it 'adds the follower user to the followers collection of the followed' do
    followers = Minitest::Mock.new
    context   = FollowUserInEntity.new(
      enforcer:         @enforcer,
      actor:            @actor,
      followed:         @followed,
      followers:        followers,
      following:        @following,
      entity:           @entity,
      actor_timeline:   @actor_timeline,
      latest_statuses:  @latest_statuses
    )
    followers.expect :add, followers, [@actor]
    context.call
    followers.verify
  end

  it 'adds a the latest page of statuses from the followed to the
    timeline of the follower' do
    actor_timeline  = Minitest::Mock.new
    context         = FollowUserInEntity.new(
      enforcer:         @enforcer,
      actor:            @actor,
      followed:         @followed,
      followers:        @followers,
      following:        @following,
      entity:           @entity,
      actor_timeline:   actor_timeline,
      latest_statuses:  @latest_statuses
    )
    actor_timeline.expect :merge, actor_timeline, [@latest_statuses]
    context.call
    actor_timeline.verify
  end
end # follow user in entity
