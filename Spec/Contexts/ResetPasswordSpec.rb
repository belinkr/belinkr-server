# encoding: utf-8
require 'minitest/autorun'
require 'redis'
require_relative '../../App/Contexts/ResetPassword'
require_relative '../../App/Contexts/RequestPasswordReset'
require_relative '../Factories/User'
require_relative '../Factories/Reset'
require_relative '../../App/Reset/Collection'

$redis ||= Redis.new
$redis.select 8

include Belinkr

describe 'reset password' do
  before do
    $redis.flushdb
    @actor        = Factory.user
    @reset        = Factory.reset
    @resets       = Reset::Collection.new
    @user_changes = User::Member.new(password: 'changed')
    RequestPasswordReset.new(@actor, @reset).call
  end

  it 'marks the reset as deleted' do
    @reset.deleted_at.must_be_nil
    ResetPassword.new(@actor, @reset, @user_changes).call
    @reset.deleted_at.wont_be_nil
  end

  it 'removes the reset from the resets collection' do
    @resets.must_include(@reset)
    ResetPassword.new(@actor, @reset, @user_changes).call
    @resets.wont_include(@reset)
  end

  it 'changes the user password' do
    previous_hash = @actor.password
    ResetPassword.new(@actor, @reset, @user_changes).call
    @actor.encrypted?.must_equal true
    @actor.password.wont_equal previous_hash
  end
end
