# encoding: utf-8
require 'minitest/autorun'
require_relative '../../App/Contexts/LogOut'
require_relative '../../App/Contexts/LogIntoEntity'
require_relative '../../App/Session/Collection'
require_relative '../Factories/User'

$redis ||= Redis.new
$redis.select 8

include Belinkr
describe 'log out' do
  before do
    $redis.flushdb
    @user     = Factory.user(password: 'test').save
    @sessions = Session::Collection.new
    @session  = LogIntoEntity.new(@user, 'test').call
  end
  it 'destroys the session' do
    @session.id.wont_be_nil
    LogOut.new(@session).call
    @session.id.must_be_nil
  end

  it 'removes the session from the session collection' do
    @sessions.must_include @session
    LogOut.new(@session).call
    @sessions.wont_include @session
  end
end

