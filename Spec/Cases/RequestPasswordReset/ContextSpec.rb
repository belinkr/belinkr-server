# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../../Cases/RequestPasswordReset/Context'
require_relative '../../Doubles/Collection/Double'
require_relative '../../Doubles/Reset/Double'
require_relative '../../Doubles/Message/Double'

include Belinkr

describe 'request password reset' do
  before do
    @actor    = OpenStruct.new
    @reset    = Reset::Double.new
    @resets   = Collection::Double.new
    @message  = Message::Double.new
  end
 
  it 'links the reset to the actor' do
    reset = Minitest::Mock.new
    context = RequestPasswordReset::Context.new(
      actor:    @actor,
      reset:    reset,
      resets:   @resets,
      message:  @message
    )
    
    reset.expect :link_to, reset, [@actor]
    context.call
    reset.verify
  end

  it 'adds the reset to the resets collection' do
    resets = Minitest::Mock.new
    context = RequestPasswordReset::Context.new(
      actor:    @actor,
      reset:    @reset,
      resets:   resets,
      message:  @message
    )

    resets.expect :add, resets, [@reset]
    context.call
    resets.verify
  end

  it 'prepares a password reset e-mail' do
    message = Minitest::Mock.new
    context = RequestPasswordReset::Context.new(
      actor:    @actor,
      reset:    @reset,
      resets:   @resets,
      message:  message
    )

    message.expect :prepare, message, [:reset_for, @actor, @reset]
    context.call
    message.verify
  end
end # request password reset

