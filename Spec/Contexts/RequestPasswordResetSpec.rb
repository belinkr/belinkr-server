# encoding: utf-8
require 'minitest/autorun'
require 'redis'
require_relative '../../App/Contexts/RequestPasswordReset'
require_relative '../Factories/User'
require_relative '../Factories/Reset'
require_relative '../../App/Reset/Collection'

$redis ||= Redis.new
$redis.select 8

include Belinkr

describe 'request password reset' do
  before do
    $redis.flushdb
    @actor  = Factory.user
    @reset  = Factory.reset
    @resets = Reset::Collection.new
  end
  
  it 'saves a new password reset' do
    @reset.created_at.must_be_nil
    RequestPasswordReset.new(@actor, @reset).call
    @reset.created_at.wont_be_nil
  end

  it 'adds the reset to the resets collection' do
    @resets.wont_include @reset
    RequestPasswordReset.new(@actor, @reset).call
    @resets.must_include @reset
  end

  it 'sends a password reset e-mail' do
    RequestPasswordReset.new(@actor, @reset).call
    message = JSON.parse($redis.rpop Belinkr::Mailer::Message::QUEUE_KEY)
    message['substitutions']['user_name'].must_equal @actor.name
  end
end
