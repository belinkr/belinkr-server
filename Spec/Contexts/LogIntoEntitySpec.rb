# encoding: utf-8
require 'minitest/autorun'
require 'redis'
require_relative '../../App/Contexts/LogIntoEntity'
require_relative '../../App/Session/Collection'
require_relative '../../Tinto/Exceptions'
require_relative '../Factories/User'

$redis ||= Redis.new
$redis.select 8

include Belinkr

describe 'log into entity' do
  before do
    $redis.flushdb
    @user     = Factory.user(password: 'test').save
    @sessions = Session::Collection.new
  end
  
  it 'saves a new session if password matches' do
    session = LogIntoEntity.new(@user, 'test').call

    session.id          .wont_be_nil
    session.user_id     .must_equal @user.id
    session.profile_id  .must_equal @user.profile_ids.first
    session.entity_id   .must_equal @user.entity_ids.first
  end

  it 'adds the session to the sessions collection' do
    session = LogIntoEntity.new(@user, 'test').call
    @sessions.must_include session
  end

  it 'raises NotAllowed if password does not match' do
    lambda { LogIntoEntity.new(@user, 'fake').call }
      .must_raise Tinto::Exceptions::NotAllowed
    @sessions.must_be_empty
  end
end # log into entity
