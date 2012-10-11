# encoding: utf-8
require 'minitest/autorun'
require_relative '../../App/Contexts/CreateProfileInEntity'
require_relative '../../App/Contexts/EditUserProfile'
require_relative '../Factories/User'
require_relative '../Factories/Entity'
require_relative '../Factories/Profile'
require_relative '../../App/Profile/Collection'

$redis ||= Redis.new
$redis.select 8

include Belinkr

describe 'edit profile' do
  before do
    $redis.flushdb

    @entity           = Factory.entity
    @user             = Factory.user(profile_ids: [])
    @user_changes     = Factory.user(@user.attributes.merge!(first: 'changed'))
    @profile          = Factory.profile
    @profile_changes  = Factory.profile(
                          @profile.attributes.merge!(mobile: 'changed'))
    @profiles         = Profile::Collection.new(entity_id: @entity.id)
    CreateProfileInEntity.new(@user, @profile, @entity).call
  end

  it 'updates user details' do
    previous_updated_at = @user.updated_at
    EditUserProfile.new(@user, @user, @user_changes, @profile, @profile_changes)
      .call

    @user.first.must_equal 'changed'
    @user.updated_at.wont_equal previous_updated_at
  end

  it 'updates profile details' do
    previous_updated_at = @profile.updated_at
    EditUserProfile.new(@user, @user, @user_changes, @profile, @profile_changes)
      .call

    @profile.mobile.must_equal 'changed'
    @profile.updated_at.wont_equal previous_updated_at
  end

  it 'updates the password if changed' do
    previous_hash           = @user.password
    @user_changes.password  = 'changed'
    EditUserProfile.new(@user, @user, @user_changes, @profile, @profile_changes)
      .call

    @user.encrypted?  .must_equal true
    @user.password    .wont_equal 'changed'
    @user.password    .wont_equal previous_hash
  end

  it 'rolls back changes to user and profile if the user is invalid' do
    user_first          = @user.first
    profile_mobile      = @profile.mobile
    @user_changes.first = 'a' * 51
    
    lambda {
      EditUserProfile
        .new(@user, @user, @user_changes, @profile, @profile_changes).call
    }.must_raise Tinto::Exceptions::InvalidResource
    
    @user.read.first      .must_equal user_first
    @profile.read.mobile  .must_equal profile_mobile
  end

  it 'rolls back changes to user and profile if the profile is invalid' do
    user_first                = @user.first
    profile_user_id           = @profile.user_id
    @profile_changes.mobile   = 'a' * 51
    
    lambda {
      EditUserProfile
        .new(@user, @user, @user_changes, @profile, @profile_changes).call
    }.must_raise Tinto::Exceptions::InvalidResource
    
    @user.read.first       .must_equal user_first
    @profile.read.user_id  .must_equal profile_user_id
  end

  it 'raises NotAllowed if actor is not the same as the user being edited' do
    lambda {
      EditUserProfile
        .new(Factory.user, @user, @user_changes, @profile, @profile_changes)
        .call
    }.must_raise Tinto::Exceptions::NotAllowed
  end
end
