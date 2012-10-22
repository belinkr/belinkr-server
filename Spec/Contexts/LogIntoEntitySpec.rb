# encoding: utf-8
require 'minitest/autorun'
require_relative '../../App/Contexts/LogIntoEntity'
require_relative '../../App/Session/Collection'
require_relative '../../Tinto/Exceptions'
require_relative '../Factories/User'

include Belinkr

describe 'log into entity' do
  before do
    @user     = Factory.user(password: 'test')
    @session  = Session::Member.new 
    @sessions = Session::Collection.new.reset
  end
  
  it 'saves a new session if password matches' do
    session = LogIntoEntity.new(@user, 'test', @session, @sessions).call

    session.id          .wont_be_nil
    session.user_id     .must_equal @user.id
    session.profile_id  .must_equal @user.profiles.first.id
    session.entity_id   .must_equal @user.profiles.first.entity_id
  end

  it 'adds the session to the sessions collection' do
    session = LogIntoEntity.new(@user, 'test', @session, @sessions).call
    @sessions.must_include session
  end

  it 'raises NotAllowed if password does not match' do
    lambda { LogIntoEntity.new(@user, 'fake', @session, @sessions).call }
      .must_raise Tinto::Exceptions::NotAllowed
    @sessions.must_be_empty
  end

  it 'raises not allowed if user is deleted' do
    @user.delete
    lambda { LogIntoEntity.new(@user, 'test', @session, @sessions).call }
      .must_raise Tinto::Exceptions::NotAllowed
    @sessions.must_be_empty
  end
end # log into entity
