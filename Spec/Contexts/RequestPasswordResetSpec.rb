# encoding: utf-8
require 'minitest/autorun'
require_relative '../../App/Contexts/RequestPasswordReset'
require_relative '../Factories/User'
require_relative '../Factories/Reset'
require_relative '../../App/Reset/Collection'
require_relative '../../Workers/Mailer/Message'

include Belinkr

describe 'request password reset' do
  before do
    @actor    = Factory.user
    @reset    = Factory.reset
    @resets   = Reset::Collection.new.reset
    @message  = Mailer::Message.new
  end
  
  it 'adds the reset to the resets collection' do
    @resets.wont_include @reset
    RequestPasswordReset.new(@actor, @reset, @resets, @message).call
    @resets.must_include @reset
  end

  it 'sends a password reset e-mail' do
    RequestPasswordReset.new(@actor, @reset, @resets, @message).call
    @message.substitutions.fetch(:user_name).must_equal @actor.name
  end
end
