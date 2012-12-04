# encoding: utf-8
require 'minitest/autorun'
require 'redis'
require_relative '../../../Resources/Session/Member'
require_relative '../../../Cases/LogOut/Request'

$redis ||= Redis.new
$redis.select 8

include Belinkr

describe 'log out request model' do
  before do
    $redis.flushdb
  end

  it 'returns data for the LogOut context' do
    session = Session::Member.new(
                user_id:    0,
                profile_id: 0,
                entity_id:  0
              ).sync
    data    = LogOut::Request.new(id: session.id).prepare

    data.fetch(:session)      .must_equal session
    data.fetch(:sessions)     .must_be_instance_of Session::Collection
  end
end

