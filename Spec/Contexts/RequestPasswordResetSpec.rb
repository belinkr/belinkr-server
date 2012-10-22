# encoding: utf-8
require 'minitest/autorun'
require_relative '../../App/Contexts/RequestPasswordReset'
require_relative '../Factories/User'
require_relative '../Factories/Reset'
require_relative '../../App/Reset/Collection'

include Belinkr

$redis ||= Redis.new
$redis.select 8

describe 'request password reset' do
  before do
    @actor  = Factory.user
    @reset  = Factory.reset
    @resets = Reset::Collection.new
  end
  
  it 'adds the reset to the resets collection' do
    @resets.wont_include @reset
    RequestPasswordReset.new(@actor, @reset, @resets).call
    @resets.must_include @reset
  end

  it 'sends a password reset e-mail' do
    RequestPasswordReset.new(@actor, @reset, @resets).call
    message = JSON.parse($redis.rpop Belinkr::Mailer::Message::QUEUE_KEY)
    message['substitutions']['user_name'].must_equal @actor.name
  end
end
