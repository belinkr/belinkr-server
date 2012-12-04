# encoding: utf-8
require 'minitest/autorun'
require 'json'
require 'redis'
require_relative '../../../Cases/ResetPassword/Request'
require_relative '../../Factories/User'

$redis ||= Redis.new
$redis.select 8

include Belinkr

describe 'request model for ResetPassword' do
  before do
    $redis.flushdb
  end

  it 'prepares data objects for the context' do
    user    = Factory.user.sync
    reset   = Reset::Member.new(
                email:    'foo@foo.com',
                user_id:  user.id
              ).sync

    payload = { reset_id: reset.id, password: 'changeme' }
    payload = JSON.parse(payload.to_json)
    data    = ResetPassword::Request.new(payload).prepare
    
    data.fetch(:actor).id .must_equal user.id
    data.fetch(:reset).id .must_equal reset.id
    data.fetch(:resets)   .must_be_instance_of Reset::Collection
    data.fetch(:user_changes).fetch('password').must_equal 'changeme'
  end
end # request model for ResetPassword

