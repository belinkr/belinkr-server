# encoding: utf-8
require 'minitest/autorun'
require_relative '../../../Cases/EditUserProfile/Context'
require_relative '../../Doubles/Enforcer/Double'
require_relative '../../Doubles/User/Double'
require_relative '../../Doubles/Profile/Double'

include Belinkr

describe 'edit user profile' do
  before do
    @enforcer         = Enforcer::Double.new
    @actor            = User::Double.new
    @user             = User::Double.new
    @profile          = Profile::Double.new
    @user_changes     = { password: 'changed' }
    @profile_changes  = { mobile: 'changed' }
  end

  it 'authorizes the actor' do
    enforcer  = Minitest::Mock.new
    context   = EditUserProfile::Context.new(
      enforcer:         enforcer,
      actor:            @actor,
      user:             @user,
      profile:          @profile,
      user_changes:     @user_changes,
      profile_changes:  @profile_changes
    )
    enforcer.expect :authorize, true, [@actor, :update]
    context.call
    enforcer.verify
  end

  it 'updates user and profile details' do
    user    = Minitest::Mock.new
    context = EditUserProfile::Context.new(
      enforcer:         @enforcer,
      actor:            @actor,
      user:             user,
      profile:          @profile,
      user_changes:     @user_changes,
      profile_changes:  @profile_changes
    )
    user.expect :update_details, user, [{
      profile:          @profile, 
      user_changes:     @user_changes, 
      profile_changes:  @profile_changes
    }]
    context.call
    user.verify
  end
end # edit user profile

