# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require 'set'
require_relative '../../../Cases/CreateProfileInEntity/Context'
require_relative '../../Doubles/Collection/Double'
require_relative '../../Doubles/User/Double'
require_relative '../../Doubles/Profile/Double'

include Belinkr

describe 'create profile in entity' do
  before do
    @actor        = User::Double.new
    @profile      = Profile::Double.new
    @entity       = OpenStruct.new
    @profiles     = Collection::Double.new
    @user_locator = Set.new
  end

  it 'links profile to the entity' do
    profile = Minitest::Mock.new
    context = CreateProfileInEntity::Context.new(
      actor:        @actor,
      profile:      profile,
      profiles:     @profiles,
      entity:       @entity,
      user_locator: @user_locator
    )

    profile.expect :link_to, profile, [@entity]
    context.call
    profile.verify
  end

  it 'registers the user to the locator service' do
    actor   = Minitest::Mock.new
    context = CreateProfileInEntity::Context.new(
      actor:        actor,
      profile:      @profile,
      profiles:     @profiles,
      entity:       @entity,
      user_locator: @user_locator
    )
    
    actor.expect :register_in, actor, [@user_locator]
    actor.expect :link_to, actor, [@profile]
    context.call
    actor.verify
  end

  it 'links user and profile' do
    actor   = Minitest::Mock.new
    context = CreateProfileInEntity::Context.new(
      actor:        actor,
      profile:      @profile,
      profiles:     @profiles,
      entity:       @entity,
      user_locator: @user_locator
    )

    actor.expect :link_to, actor, [@profile]
    actor.expect :register_in, actor, [@user_locator]
    context.call
    actor.verify
  end

  it 'adds the profile to the profiles collection of this entity' do
    profiles  = Minitest::Mock.new
    context   = CreateProfileInEntity::Context.new(
      actor:        @actor,
      profile:      @profile,
      profiles:     profiles,
      entity:       @entity,
      user_locator: @user_locator
    )
    
    profiles.expect :add, profiles, [@profile]
    context.call
    profiles.verify
  end
end # create profile in entity

