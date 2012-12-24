# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../../Cases/GetStatus/Context'

include Belinkr

describe 'GetStatus' do
  it 'authorizes the actor' do
    actor   = OpenStruct.new
    status  = OpenStruct.new

    enforcer  = Minitest::Mock.new
    context   = GetStatus::Context.new(
      actor:    actor,
      status:   status,
      enforcer: enforcer
    )

    enforcer.expect :authorize, enforcer, [actor, :get_status]
    context.call
    enforcer.verify
  end
end # GetStatus

