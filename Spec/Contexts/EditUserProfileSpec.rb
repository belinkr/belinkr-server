# encoding: utf-8
require 'minitest/autorun'
require 'redis'
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
    @user             = Factory.user(profiles: [])
    @user_changes     = {first: 'changed' }
    @profile          = Factory.profile
    @profile_changes  = { mobile: 'changed' }
    @profiles         = Profile::Collection.new(entity_id: @entity.id)

    CreateProfileInEntity.new(@user, @profile, @profiles, @entity).call
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

  it 'keeps the profile updated within the profiles field of the user' do
    user, profile = @user.dup, @profile.dup
    user.profiles = [profile]
    previous_updated_at = @profile.updated_at
    EditUserProfile.new(user, user, @user_changes, @profile, @profile_changes)
      .call

    user.profiles.length.must_equal 1
    user.profiles.first.mobile.must_equal 'changed'
    user.profiles.first.updated_at.wont_equal previous_updated_at
  end

  it 'updates the password if changed' do
    @user_changes = { password: 'changed' }
    previous_hash = @user.password
    EditUserProfile.new(@user, @user, @user_changes, @profile, @profile_changes)
      .call

    @user.encrypted?  .must_equal true
    @user.password    .wont_equal 'changed'
    @user.password    .wont_equal previous_hash
  end

  it 'raises NotAllowed if actor is not the same as the user being edited' do
    lambda {
      EditUserProfile
        .new(Factory.user, @user, @user_changes, @profile, @profile_changes)
        .call
    }.must_raise Tinto::Exceptions::NotAllowed
  end
end
