# encoding: utf-8
require 'minitest/autorun'
require_relative '../../App/Contexts/UpdateTimelines'
require_relative '../Factories/User'
require_relative '../Factories/Profile'
require_relative '../Factories/Status'

include Belinkr


describe UpdateTimelines do
  before do
    @actor      = Factory.user
    @context    = Factory.profile
    @status     = Factory.status(author: @actor, contexts: @context)
    @followers  = []
  end

  it 'updates timelines' do
    UpdateTimelines.new(@actor, @status, @context).call do |timeline|
      timeline.add @status
    end
  end
end # UpdateTimelines

