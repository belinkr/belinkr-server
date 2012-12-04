require 'minitest/autorun'
require 'json'
require_relative '../../../Cases/RequestPasswordReset/Request'
require_relative '../../Factories/User'

$redis ||= Redis.new
$redis.select 8

include Belinkr

describe 'request model for RequestPasswordReset' do
  before do
    $redis.flushdb
    @locator = User::Locator.new
  end

  it 'prepares data objects for the context' do
    user    = Factory.user.sync
    @locator.add(user.email, user.id)
    @locator.sync

    payload = { email: user.email }
    payload = JSON.parse(payload.to_json)
    data    = RequestPasswordReset::Request.new(payload).prepare
    
    data.fetch(:actor)    .must_be_instance_of User::Member
    data.fetch(:reset)    .must_be_instance_of Reset::Member
    data.fetch(:resets)   .must_be_instance_of Reset::Collection
    data.fetch(:message)  .must_be_instance_of Message::Member
  end
end # request model for RequestPasswordReset

