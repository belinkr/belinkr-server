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

  it 'returns data objects for the LogOut context' do
    actor = Factory.user(password: 'changeme')
    actor.sync
    user_locator = User::Locator.new
    user_locator.add actor.email, actor.id
    user_locator.sync
    
    payload = { 
      email:    actor.email,
      password: 'changeme',
      remember: nil
    }.to_json
    payload = JSON.parse(payload)

    data    = LogIn::Request.new(payload: payload).prepare

    data.fetch(:actor).id   .must_equal actor.id
    data.fetch(:plaintext)  .must_equal payload.fetch('password')
    data.fetch(:session)    .must_be_instance_of Session::Member
    data.fetch(:sessions)   .must_be_instance_of Session::Collection
  end
end

