# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require 'set'
require_relative '../../../Cases/GetTimeline/Context'

include Belinkr

describe 'GetTimeline' do
  it 'authorizes the actor' do
    actor       = OpenStruct.new
    timeline  = Set.new

    enforcer    = Minitest::Mock.new
    context     = GetTimeline::Context.new(
      actor:      actor,
      timeline: timeline,
      enforcer:   enforcer
    )

    enforcer.expect :authorize, enforcer, [actor, :get_timeline]
    context.call
    enforcer.verify
  end
end # GetTimeline

