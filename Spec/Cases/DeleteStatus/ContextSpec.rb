# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../../Cases/DeleteStatus/Context'
require_relative '../../Doubles/Collection/Double'
require_relative '../../Doubles/Status/Double'
require_relative '../../Doubles/Enforcer/Double'

include Belinkr

describe 'delete status' do
  before do
    @enforcer   = Enforcer::Double.new
    @actor      = OpenStruct.new
    @status     = Status::Double.new
    @timeline   = Collection::Double.new
    @timelines  = [@timeline]

    def @timeline.delete(*args); true; end
  end

  it 'authorizes the actor' do
    enforcer  = Minitest::Mock.new
    context   = DeleteStatus::Context.new(
      enforcer:   enforcer,
      actor:      @actor,
      status:     @status,
      timelines:  @timelines
    )
    enforcer.expect :authorize, enforcer, [@actor, :delete_status]
    context.call
    enforcer.verify
  end

  it 'marks the status as deleted' do
    status    = Minitest::Mock.new
    context   = DeleteStatus::Context.new(
      enforcer:   @enforcer,
      actor:      @actor,
      status:     status,
      timelines:  @timelines
    )
    status.expect :delete, status
    context.call
    status.verify
  end

  it 'deletes the status to all applicable timelines' do
    timeline  = Minitest::Mock.new
    context   = DeleteStatus::Context.new(
      enforcer:   @enforcer,
      actor:      @actor,
      status:     @status,
      timelines:  [timeline]
    )
    timeline.expect :delete, timeline, [@status]
    context.call
    timeline.verify
  end
end # delete status

