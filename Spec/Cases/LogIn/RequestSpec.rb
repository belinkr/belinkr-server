# encoding: utf-8
require 'minitest/autorun'
require 'redis'
require_relative '../../Factories/User'
require_relative '../../../Cases/LogIn/Request'

$redis ||= Redis.new
$redis.select 8

include Belinkr

describe 'log out request model' do
  before { $redis.flushdb }

  it 'returns data objects for the Log Out context' do
    user = Factory.user(password: 'changeme')
    user.sync
    user_locator = User::Locator.new
    user_locator.add user.email, user.id
    user_locator.sync
    
    payload = { 
      email:    user.email,
      password: 'changeme',
      remember: nil
    }.to_json
    payload = JSON.parse(payload)

    request = LogIn::Request.new(payload)
    data    = request.prepare

    data.fetch(:actor).id   .must_equal user.id
    data.fetch(:plaintext)  .must_equal payload.fetch('password')
    data.fetch(:session)    .must_be_instance_of Session::Member
    data.fetch(:sessions)   .must_be_instance_of Session::Collection
  end
end

