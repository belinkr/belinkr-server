# encoding: utf-8
require 'minitest/autorun'
require_relative '../../../Cases/ResetPassword/Context'
require_relative '../../Doubles/User/Double'
require_relative '../../Doubles/Reset/Double'
require_relative '../../Doubles/Collection/Double'

include Belinkr

describe 'reset password' do
  before do
    @actor        = User::Double.new
    @user_changes = { password: 'changed' }
    @reset        = Reset::Double.new
    @resets       = Collection::Double.new
  end

  it 'marks the reset as deleted' do
    reset = Minitest::Mock.new
    context = ResetPassword::Context.new(
      actor:        @actor,
      reset:        reset,
      resets:       @resets,
      user_changes: @user_changes
    )
    reset.expect :delete, reset
    context.call
    reset.verify
  end

  it 'removes the reset from the resets collection' do
    resets = Minitest::Mock.new
    context = ResetPassword::Context.new(
      actor:        @actor,
      reset:        @reset,
      resets:       resets,
      user_changes: @user_changes
    )

    resets.expect :delete, resets, [@reset]
    context.call
    resets.verify
  end

  it 'updates the actor' do
    actor = Minitest::Mock.new
    context = ResetPassword::Context.new(
      actor:        actor,
      reset:        @reset,
      resets:       @resets,
      user_changes: @user_changes
    )

    actor.expect :update, actor, [@user_changes]
    context.call
    actor.verify
  end
end # reset password

