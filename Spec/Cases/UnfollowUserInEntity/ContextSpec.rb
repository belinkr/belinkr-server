# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../../Cases/UnfollowUserInEntity/Context'
require_relative '../../Doubles/Enforcer/Double'
require_relative '../../Doubles/User/Double'
require_relative '../../Doubles/Profile/Double'
require_relative '../../Doubles/Collection/Double'

include Belinkr

describe 'unfollow user in entity' do
  before do
    @enforcer         = Enforcer::Double.new
    @actor            = User::Double.new
    @actor_profile    = Profile::Double.new
    @followed         = User::Double.new
    @followed_profile = Profile::Double.new
    @followers        = Collection::Double.new
    @following        = Collection::Double.new
    @entity           = OpenStruct.new
  end

  it 'authorizes the actor' do
    enforcer  = Minitest::Mock.new
    context   = UnfollowUserInEntity::Context.new(
      enforcer:         enforcer,
      actor:            @actor,
      followed:         @followed,
      actor_profile:    @actor_profile,
      followed_profile: @followed_profile,
      followers:        @followers,
      following:        @following,
      entity:           @entity
    )
    enforcer.expect :authorize, enforcer, [@actor, :unfollow]
    context.call
    enforcer.verify
  end

  it 'removes the followed user 
  from the following collection of the follower' do
    following = Minitest::Mock.new
    context   = UnfollowUserInEntity::Context.new(
      enforcer:         @enforcer,
      actor:            @actor,
      followed:         @followed,
      actor_profile:    @actor_profile,
      followed_profile: @followed_profile,
      followers:        @followers,
      following:        following,
      entity:           @entity
    )
    following.expect :delete, following, [@followed]
    context.call
    following.verify
  end

  it 'removes the follower user 
  from the followers collection of the followed' do
    followers = Minitest::Mock.new
    context   = UnfollowUserInEntity::Context.new(
      enforcer:         @enforcer,
      actor:            @actor,
      followed:         @followed,
      actor_profile:    @actor_profile,
      followed_profile: @followed_profile,
      followers:        followers,
      following:        @following,
      entity:           @entity
    )
    followers.expect :delete, followers, [@actor]
    context.call
    followers.verify
  end

  it 'decrements the followers counter of the followed' do
    followed_profile  = Minitest::Mock.new
    context           = UnfollowUserInEntity::Context.new(
      enforcer:         @enforcer,
      actor:            @actor,
      followed:         @followed,
      actor_profile:    @actor_profile,
      followed_profile: followed_profile,
      followers:        @followers,
      following:        @following,
      entity:           @entity
    )
    followed_profile.expect :decrement_followers_counter, followed_profile
    context.call
    followed_profile.verify
  end

  it 'decrements the following counter of the actor' do
    actor_profile = Minitest::Mock.new
    context       = UnfollowUserInEntity::Context.new(
      enforcer:         @enforcer,
      actor:            @actor,
      followed:         @followed,
      actor_profile:    actor_profile,
      followed_profile: @followed_profile,
      followers:        @followers,
      following:        @following,
      entity:           @entity
    )
    actor_profile.expect :decrement_following_counter, actor_profile
    context.call
    actor_profile.verify
  end
end # unfollow user in entity

