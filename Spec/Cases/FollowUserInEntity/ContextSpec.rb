# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../../Cases/FollowUserInEntity/Context'
require_relative '../../Doubles/Enforcer/Double'
require_relative '../../Doubles/Collection/Double'
require_relative '../../Doubles/Profile/Double'

include Belinkr

describe 'follow user in entity' do
  before do
    @enforcer         = Enforcer::Double.new
    @actor            = OpenStruct.new
    @followed         = OpenStruct.new
    @actor_profile    = Profile::Double.new
    @followed_profile = Profile::Double.new
    @followers        = Collection::Double.new
    @following        = Collection::Double.new
    @entity           = OpenStruct.new
    @actor_timeline   = Collection::Double.new
    @latest_statuses  = Collection::Double.new
  end

  it 'authorizes the user' do
    enforcer  = Minitest::Mock.new
    context   = FollowUserInEntity::Context.new(
      enforcer:         enforcer,
      actor:            @actor,
      followed:         @followed,
      actor_profile:    @actor_profile,
      followed_profile: @followed_profile,
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
    context   = FollowUserInEntity::Context.new(
      enforcer:         @enforcer,
      actor:            @actor,
      followed:         @followed,
      followers:        @followers,
      actor_profile:    @actor_profile,
      followed_profile: @followed_profile,
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
    context   = FollowUserInEntity::Context.new(
      enforcer:         @enforcer,
      actor:            @actor,
      followed:         @followed,
      actor_profile:    @actor_profile,
      followed_profile: @followed_profile,
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
    context         = FollowUserInEntity::Context.new(
      enforcer:         @enforcer,
      actor:            @actor,
      followed:         @followed,
      actor_profile:    @actor_profile,
      followed_profile: @followed_profile,
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

  it 'increments the followers counter of the followed profile' do
    followed_profile  = Minitest::Mock.new
    context           = FollowUserInEntity::Context.new(
      enforcer:         @enforcer,
      actor:            @actor,
      followed:         @followed,
      actor_profile:    @actor_profile,
      followed_profile: followed_profile,
      followers:        @followers,
      following:        @following,
      entity:           @entity,
      actor_timeline:   @actor_timeline,
      latest_statuses:  @latest_statuses
    )
    followed_profile.expect :increment_followers_counter, followed_profile
    context.call
    followed_profile.verify
  end

  it 'increments the following counter of the actor profile' do
    actor_profile = Minitest::Mock.new
    context       = FollowUserInEntity::Context.new(
      enforcer:         @enforcer,
      actor:            @actor,
      followed:         @followed,
      actor_profile:    actor_profile,
      followed_profile: @followed_profile,
      followers:        @followers,
      following:        @following,
      entity:           @entity,
      actor_timeline:   @actor_timeline,
      latest_statuses:  @latest_statuses
    )
    actor_profile.expect :increment_following_counter, actor_profile
    context.call
    actor_profile.verify
  end
end # follow user in entity

