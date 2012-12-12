# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../../Cases/GetMember/Context'

include Belinkr

describe 'GetMember' do
  it 'authorizes the actor' do
    actor   = OpenStruct.new
    member  = OpenStruct.new

    enforcer  = Minitest::Mock.new
    context   = GetMember::Context.new(
      actor:    actor,
      member:   member,
      enforcer: enforcer
    )

    enforcer.expect :authorize, enforcer, [actor, :read]
    context.call
    enforcer.verify
  end
end # GetMember

