# encoding: utf-8
require 'minitest/autorun'
require_relative '../../App/Contexts/ResetPassword'
require_relative '../../App/Contexts/RequestPasswordReset'
require_relative '../../Workers/Mailer/Message'
require_relative '../Factories/User'
require_relative '../Factories/Reset'
require_relative '../../App/Reset/Collection'

include Belinkr

describe 'reset password' do
  before do
    @actor        = Factory.user
    @user_changes = { password: 'changed' }
    @reset        = Reset::Member.new
    @resets       = Reset::Collection.new.reset
    @message      = Mailer::Message.new
    RequestPasswordReset.new(@actor, @reset, @resets, @message).call
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
