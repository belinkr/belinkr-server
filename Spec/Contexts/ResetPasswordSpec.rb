# encoding: utf-8
require 'minitest/autorun'
require 'redis'
require_relative '../../App/Contexts/ResetPassword'
require_relative '../../App/Contexts/RequestPasswordReset'
require_relative '../Factories/User'
require_relative '../Factories/Reset'
require_relative '../../App/Reset/Collection'

include Belinkr
$redis ||= Redis.new
$redis.select 8

describe 'reset password' do
  before do
    $redis.flushdb
    @actor        = Factory.user
    @user_changes = @actor.dup
    @user_changes.password = 'changed'
    @reset        = Reset::Member.new
    @resets       = Reset::Collection.new
    RequestPasswordReset.new(@actor, @reset, @resets).call
  end

  it 'marks the reset as deleted' do
    @reset.deleted_at.must_be_nil
    ResetPassword.new(@actor, @user_changes, @reset, @resets).call
    @reset.deleted_at.wont_be_nil
  end

  it 'removes the reset from the resets collection' do
    @resets.must_include(@reset)
    ResetPassword.new(@actor, @user_changes, @reset, @resets).call
    @resets.wont_include(@reset)
  end

  it 'changes the user password' do
    previous_hash = @actor.password
    ResetPassword.new(@actor, @user_changes, @reset, @resets).call
    @actor.encrypted?.must_equal true
    @actor.password.wont_equal previous_hash
  end
end
