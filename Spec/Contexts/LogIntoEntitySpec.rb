# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../App/Contexts/LogIntoEntity'
require_relative '../Doubles/Collection/Double'
require_relative '../Doubles/User/Double'

include Belinkr

describe 'log into entity' do
  it 'validates user and password' do
    actor     = Minitest::Mock.new
    session   = OpenStruct.new
    sessions  = Collection::Double.new
    plaintext = 'secret'

    context   = LogIntoEntity.new(
      actor:      actor, 
      plaintext:  plaintext, 
      session:    session, 
      sessions:   sessions
    )
    actor.expect :authenticate, session, [session, plaintext]
    context.call
    actor.verify
  end

  it 'adds the session to the sessions collection' do
    actor     = User::Double.new
    session   = OpenStruct.new
    sessions  = Minitest::Mock.new
    plaintext = 'secret'

    context   = LogIntoEntity.new(
      actor:      actor, 
      plaintext:  plaintext, 
      session:    session, 
      sessions:   sessions
    )
    sessions.expect :add, sessions, [session]
    context.call
    sessions.verify
  end
end # log into entity

