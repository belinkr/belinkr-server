# encoding: utf-8
require 'minitest/autorun'
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

    @user     = Factory.user(profile_ids: [], entity_ids: [])
    @profile  = Factory.profile
    @entity   = Factory.entity
    @profiles = Profile::Collection.new(entity_id: @entity.id)
  end

  it 'links the user to the profile and the entity' do
    @user.profile_ids.wont_include @profile.id
    @user.entity_ids.wont_include @entity.id
    CreateProfileInEntity.new(@user, @profile, @entity).call

    @user.profile_ids.must_include @profile.id
    @user.entity_ids.must_include @entity.id
  end

  it 'links the profile to the user' do
    @profile.user_id = nil
    CreateProfileInEntity.new(@user, @profile, @entity).call
    @profile.user_id.must_equal @user.id
  end

  it 'links the profile to the entity' do
    @profile.entity_id = nil
    CreateProfileInEntity.new(@user, @profile, @entity).call
    @profile.entity_id.must_equal @entity.id
  end

  it 'saves the user' do
    @user.created_at.must_be_nil
    CreateProfileInEntity.new(@user, @profile, @entity).call
    @user.created_at.wont_be_nil
  end

  it 'updates data on the user locator' do
    lambda { User::Locator.user_from(@user.email) }
      .must_raise Tinto::Exceptions::NotFound
    CreateProfileInEntity.new(@user, @profile, @entity).call
    User::Locator.user_from(@user.email).to_json.must_equal @user.to_json
  end

  it 'saves the profile' do
    @profile.created_at.must_be_nil
    CreateProfileInEntity.new(@user, @profile, @entity).call
    @profile.created_at.wont_be_nil
  end

  it 'adds the profile to the profiles collection of this entity' do
    CreateProfileInEntity.new(@user, @profile, @entity).call
    @profiles.must_include @profile
  end

  it 'raises if the user is not valid' do
    @user.first = nil

    lambda { 
      CreateProfileInEntity.new(@user, @profile, @entity).call
    }.must_raise Tinto::Exceptions::InvalidResource

    @profile.created_at.must_be_nil
    @profiles.wont_include @profile
    @user.created_at.must_be_nil
    @user.profile_ids.must_be_empty
  end

  it 'raises if the profile is not valid' do
    @user.first = nil
    @profile.id = nil

    lambda { 
      CreateProfileInEntity.new(@user, @profile, @entity).call
    }.must_raise Tinto::Exceptions::InvalidResource

    @profile.created_at.must_be_nil
    @profiles.wont_include @profile
    @user.created_at.must_be_nil
    @user.profile_ids.must_be_empty
    @user.entity_ids.must_be_empty
  end

  describe 'when an exception is raised' do
    it 'will roll back user creation (destroy) if this was his first profile' do
      @user.first = nil
      lambda { 
        CreateProfileInEntity.new(@user, @profile, @entity).call
      }.must_raise Tinto::Exceptions::InvalidResource

      @user.created_at.must_be_nil
    end

    it 'will not destroy the user if it had previously existing profiles' do
      @user.profile_ids = [2]
      @user.save
      @user.first = nil

      lambda { 
        CreateProfileInEntity.new(@user, @profile, @entity).call
      }.must_raise Tinto::Exceptions::InvalidResource

      @user.created_at.wont_be_nil
    end
  end
end

