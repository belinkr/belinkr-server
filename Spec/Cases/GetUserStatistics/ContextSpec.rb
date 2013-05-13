# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require 'set'
require_relative '../../../Cases/GetUserStatistics/Context'

include Belinkr

describe 'GetUserStatistics' do
  it 'authorizes the actor' do
    actor       = OpenStruct.new
    user        = OpenStruct.new
    timeline  = Set.new

    enforcer    = Minitest::Mock.new
    context     = GetUserStatistics::Context.new(
      actor:      actor,
      user:       user,
      enforcer:   enforcer
    )

    enforcer.expect :authorize, enforcer, [actor, :get_user_statistics]
    context.call
    enforcer.verify
  end
end # GetTimeline

