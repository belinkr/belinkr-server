# encoding: utf-8
require 'minitest/autorun'
require_relative '../../App/Contexts/RemoveProfileFromEntity'
require_relative '../../App/Contexts/CreateProfileInEntity'
require_relative '../Factories/User'
require_relative '../Factories/Entity'
require_relative '../Factories/Profile'
require_relative '../../App/Profile/Collection'
require_relative '../../Tinto/Exceptions'

$redis ||= Redis.new
$redis.select 8

include Belinkr

describe 'remove user from entity' do
  before do
    @user     = Factory.user(profile_ids: [], entity_ids: [])
    @profile  = Factory.profile
    @entity   = Factory.entity
    @profiles = Profile::Collection.new(entity_id: @entity.id)
    CreateProfileInEntity.new(@user, @profile, @entity).call
  end

  it 'unlinks the user from the entity' do
    RemoveProfileFromEntity.new(@user, @user, @profile, @entity).call
    @user.entity_ids.wont_include @entity.id
  end

  it 'unlinks the profile from the user' do
    RemoveProfileFromEntity.new(@user, @user, @profile, @entity).call
    @user.profile_ids.wont_include @profile.id
    @profile.deleted_at.wont_be_nil
  end

  it 'unlinks the profile from the entity by removing it 
  from the profiles collection of that entity' do
    RemoveProfileFromEntity.new(@user, @user, @profile, @entity).call
    @profiles.wont_include @profile
  end

  it 'deletes the user if this was his only profile' do
    @user.deleted_at.must_be_nil
    RemoveProfileFromEntity.new(@user, @user, @profile, @entity).call
    @user.deleted_at.wont_be_nil
  end

  it 'keeps the user if it is linked to other profiles in other entities' do
    CreateProfileInEntity.new(@user, Factory.profile, Factory.entity.save).call
    @user.deleted_at.must_be_nil
    @user.profile_ids.length.must_equal 2
    @user.entity_ids.length.must_equal 2

    RemoveProfileFromEntity.new(@user, @user, @profile, @entity).call
    @user.deleted_at.must_be_nil
    @user.profile_ids.length.must_equal 1
    @user.profile_ids.wont_include @profile.id
    @user.entity_ids.length.must_equal 1
    @user.entity_ids.wont_include @entity.id
  end

  it 'raises if the actor is not the same as the user being removed' do
    lambda {
      RemoveProfileFromEntity.new(Factory.user, @user, @profile, @entity).call
    }.must_raise Tinto::Exceptions::NotAllowed
  end
end

