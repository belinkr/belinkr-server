# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../App/Contexts/LogOut'
require_relative '../Doubles/Collection/Double'

include Belinkr

describe 'log out' do
  it 'expires the session' do
    session   = Minitest::Mock.new
    sessions  = Collection::Double.new
    context   = LogOut.new(session: session, sessions: sessions)

    session.expect :expire, session
    context.call
    session.verify
  end

  it 'removes the session from the session collection' do
    session   = OpenStruct.new
    sessions  = Minitest::Mock.new
    context   = LogOut.new(session: session, sessions: sessions)

    sessions.expect :delete, sessions, [session]
    context.call
    sessions.verify
  end
end # log out

