# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require 'set'
require_relative '../../../Cases/GetCollection/Context'

include Belinkr

describe 'GetCollection' do
  it 'authorizes the actor' do
    actor       = OpenStruct.new
    collection  = Set.new

    enforcer    = Minitest::Mock.new
    context     = GetCollection::Context.new(
      actor:      actor,
      collection: collection,
      enforcer:   enforcer
    )

    enforcer.expect :authorize, enforcer, [actor, :collection]
    context.call
    enforcer.verify
  end
end # GetCollection

