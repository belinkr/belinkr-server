# encoding: utf-8
require 'minitest/autorun'
require_relative '../../App/Contexts/RemoveProfileFromEntity'
require_relative '../Doubles/Enforcer/Double'
require_relative '../Doubles/User/Double'
require_relative '../Doubles/Profile/Double'
require_relative '../Doubles/Collection/Double'

include Belinkr

describe 'remove user from entity' do
  before do
    @enforcer = Enforcer::Double.new
    @actor    = User::Double.new
    @user     = User::Double.new
    @profile  = Profile::Double.new
    @profiles = Collection::Double.new
  end

  it 'authorizes the user' do
    enforcer = Minitest::Mock.new
    enforcer.expect :authorize, enforcer, [@actor, :delete]

    context = RemoveProfileFromEntity.new(
      enforcer: enforcer,
      actor:    @actor,
      user:     @user,
      profile:  @profile,
      profiles: @profiles
    )
    context.call
    enforcer.verify
  end

  it 'unlinks the user from the profile' do
    user = Minitest::Mock.new
    user.expect :unlink_from, user, [@profile]

    context = RemoveProfileFromEntity.new(
      enforcer: @enforcer,
      actor:    @actor,
      user:     user,
      profile:  @profile,
      profiles: @profiles
    )
    context.call
    user.verify
  end

  it 'marks the profile as deleted' do
    profile = Minitest::Mock.new
    profile.expect :delete, profile

    context = RemoveProfileFromEntity.new(
      enforcer: @enforcer,
      actor:    @actor,
      user:     @user,
      profile:  profile,
      profiles: @profiles
    )
    context.call
    profile.verify
  end

  it 'deletes the profile from the profiles collection of the entity' do
    profiles = Minitest::Mock.new
    profiles.expect :delete, profiles, [@profile]

    context = RemoveProfileFromEntity.new(
      enforcer: @enforcer,
      actor:    @actor,
      user:     @user,
      profile:  @profile,
      profiles: profiles
    )
    context.call
    profiles.verify
  end
end

