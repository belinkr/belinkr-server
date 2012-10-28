# encoding: utf-8
require 'minitest/autorun'
require_relative '../../App/Contexts/LogOut'
require_relative '../../App/Contexts/LogIntoEntity'
require_relative '../../App/Session/Collection'
require_relative '../Factories/User'

include Belinkr

describe 'log out' do
  before do
    @user     = Factory.user(password: 'test')
    @session  = Session::Member.new
    @sessions = Session::Collection.new.reset
    LogIntoEntity.new(@user, 'test', @session, @sessions).call
  end

  it 'destroys the session' do
    @session.id.wont_be_nil
    LogOut.new(@session, @sessions).call
    @session.id.must_be_nil
  end

  it 'removes the session from the session collection' do
    @sessions.must_include @session
    LogOut.new(@session, @sessions).call
    @sessions.wont_include @session
  end
end

