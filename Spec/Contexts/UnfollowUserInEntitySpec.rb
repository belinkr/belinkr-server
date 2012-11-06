# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../App/Contexts/UnfollowUserInEntity'
require_relative '../Doubles/Enforcer/Double'
require_relative '../Doubles/User/Double'
require_relative '../Doubles/Collection/Double'

include Belinkr

describe 'unfollow user in entity' do
  before do
    @enforcer   = Enforcer::Double.new
    @actor      = User::Double.new
    @followed   = User::Double.new
    @followers  = Collection::Double.new
    @following  = Collection::Double.new
    @entity     = OpenStruct.new
  end

  it 'authorizes the actor' do
    enforcer  = Minitest::Mock.new
    context   = UnfollowUserInEntity.new(
      enforcer:   enforcer,
      actor:      @actor,
      followed:   @followed,
      followers:  @followers,
      following:  @following,
      entity:     @entity
    )
    enforcer.expect :authorize, enforcer, [@actor, :unfollow]
    context.call
    enforcer.verify
  end

  it 'removes the followed user 
  from the following collection of the follower' do
    following = Minitest::Mock.new
    context   = UnfollowUserInEntity.new(
      enforcer:   @enforcer,
      actor:      @actor,
      followed:   @followed,
      followers:  @followers,
      following:  following,
      entity:     @entity
    )
    following.expect :delete, following, [@followed]
    context.call
    following.verify
  end

  it 'removes the follower user 
  from the followers collection of the followed' do
    followers = Minitest::Mock.new
    context   = UnfollowUserInEntity.new(
      enforcer:   @enforcer,
      actor:      @actor,
      followed:   @followed,
      followers:  followers,
      following:  @following,
      entity:     @entity
    )
    followers.expect :delete, followers, [@actor]
    context.call
    followers.verify
  end
end # unfollow user in entity

