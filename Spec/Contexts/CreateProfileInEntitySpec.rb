# encoding: utf-8
require 'minitest/autorun'
require 'redis'
require_relative '../../App/Contexts/CreateProfileInEntity'
require_relative '../../App/Profile/Collection'
require_relative '../../App/User/Locator'
require_relative '../Factories/User'
require_relative '../Factories/Entity'
require_relative '../Factories/Profile'

$redis ||= Redis.new
$redis.select 8

include Belinkr

describe 'create profile in entity' do
  before do
    $redis.flushdb

    @user     = Factory.user(profiles: [])
    @entity   = Factory.entity
    @profile  = Factory.profile
    @profiles = Profile::Collection.new(entity_id: @entity.id)
  end

  it 'links the user to the profile and the entity' do
    @user.profiles.wont_include @profile
    CreateProfileInEntity.new(@user, @profile, @profiles, @entity).call
    @user.profiles.must_include @profile
  end

  it 'links the profile to the user' do
    @profile.user_id = nil
    CreateProfileInEntity.new(@user, @profile, @profiles, @entity).call
    @profile.user_id.must_equal @user.id
  end

  it 'links the profile to the entity' do
    @profile.entity_id = nil
    CreateProfileInEntity.new(@user, @profile, @profiles, @entity).call
    @profile.entity_id.must_equal @entity.id
  end

  it 'updates data on the user locator' do
    lambda { User::Locator.user_from(@user.email) }
      .must_raise Tinto::Exceptions::NotFound
    CreateProfileInEntity.new(@user, @profile, @profiles, @entity).call
    @user.sync
    User::Locator.user_from(@user.email).id.must_equal @user.id
  end

  it 'adds the profile to the profiles collection of this entity' do
    CreateProfileInEntity.new(@user, @profile, @profiles, @entity).call
    @profiles.must_include @profile
  end

  it 'raises if the user is not valid' do
    @user.first = nil

    lambda { 
      CreateProfileInEntity.new(@user, @profile, @profiles, @entity).call
    }.must_raise Tinto::Exceptions::InvalidMember

    @profiles.wont_include @profile
    @user.profiles.must_be_empty
  end

  it 'raises if the profile is not valid' do
    @user.first = nil
    @profile.id = nil

    lambda { 
      CreateProfileInEntity.new(@user, @profile, @profiles, @entity).call
    }.must_raise Tinto::Exceptions::InvalidMember

    @profiles.wont_include @profile
    @user.profiles.must_be_empty
  end
end

