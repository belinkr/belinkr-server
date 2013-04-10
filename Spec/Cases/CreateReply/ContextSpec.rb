# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../../Cases/CreateReply/Context'
require_relative '../../Doubles/Enforcer/Double'

include Belinkr

describe 'create status reply' do
  before do
    @enforcer   = Enforcer::Double.new
    @actor      = OpenStruct.new
    @reply     = OpenStruct.new

    @status     = OpenStruct.new
    @status.replies = Minitest::Mock.new
    @status.replies.expect :<<, [@reply], [@reply]
  end

  it 'authorizes the actor' do
    enforcer = Minitest::Mock.new
    context = CreateReply::Context.new(
                 enforcer:   enforcer,
                 actor:      @actor,
                 status:     @status,
                 reply:      @reply
    )
    enforcer.expect :authorize, true, [@actor, :create]
    context.call
    enforcer.verify
  end

  it 'append reply to replies array' do
    @status.id = 3
    context = CreateReply::Context.new(
                 enforcer:   @enforcer,
                 actor:      @actor,
                 status:     @status,
                 reply:      @reply
    )
    context.call

    @status.replies.verify
    @reply.status_id.must_equal @status.id
  end

  it 'sync the status' do
    context = CreateReply::Context.new(
                 enforcer:   @enforcer,
                 actor:      @actor,
                 status:     @status,
                 reply:      @reply
    )
    context.call
    context.syncables.must_include @status

  end
end

