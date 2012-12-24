# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../../Cases/CreateStatus/Context'
require_relative '../../Doubles/Enforcer/Double'

include Belinkr

describe 'create status' do
  before do
    @enforcer   = Enforcer::Double.new
    @actor      = OpenStruct.new
    @status     = OpenStruct.new
    @timeline   = OpenStruct.new
    @timelines  = [@timeline]

    def @timeline.add(*args); true; end
  end

  it 'authorizes the actor' do
    enforcer  = Minitest::Mock.new
    context   = CreateStatus::Context.new(
      enforcer:   enforcer,
      actor:      @actor,
      status:     @status,
      timelines:  @timelines
    )
    enforcer.expect :authorize, enforcer, [@actor, :create_status]
    context.call
    enforcer.verify
  end

  it 'adds the status to all applicable timelines' do
    timeline  = Minitest::Mock.new
    context   = CreateStatus::Context.new(
      enforcer:   @enforcer,
      actor:      @actor,
      status:     @status,
      timelines:  [timeline]
    )
    timeline.expect :add, timeline, [@status]
    context.call
    timeline.verify
  end
end # create status

