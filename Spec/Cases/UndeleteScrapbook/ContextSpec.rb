# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../../Cases/UndeleteScrapbook/Context'
require_relative '../../Doubles/Collection/Double'
require_relative '../../Doubles/Scrapbook/Double'
require_relative '../../Doubles/Enforcer/Double'

include Belinkr

describe 'undelete scrapbook' do
  before do
    @enforcer   = Enforcer::Double.new
    @actor      = OpenStruct.new
    @scrapbook  = Scrapbook::Double.new
    @scrapbooks = Collection::Double.new
  end

  it 'authorizes the actor' do
    enforcer  = Minitest::Mock.new
    context   = UndeleteScrapbook::Context.new(
      enforcer:   enforcer,
      actor:      @actor,
      scrapbook:  @scrapbook, 
      scrapbooks: @scrapbooks
    )
    enforcer.expect :authorize, enforcer, [@actor, :undelete]
    context.call
    enforcer.verify
  end
  it 'marks the scrapbook as not deleted' do
    scrapbook = Minitest::Mock.new
    context   = UndeleteScrapbook::Context.new(
      enforcer:   @enforcer,
      actor:      @actor,
      scrapbook:  scrapbook, 
      scrapbooks: @scrapbooks
    )
    scrapbook.expect :undelete, scrapbook
    context.call
    scrapbook.verify
  end

  it 'adds the scrapbook to own the scrapbooks collection of the actor' do
    scrapbooks  = Minitest::Mock.new
    context     = UndeleteScrapbook::Context.new(
      enforcer:   @enforcer,
      actor:      @actor,
      scrapbook:  @scrapbook,
      scrapbooks: scrapbooks
    )
    scrapbooks.expect :add, scrapbooks, [@scrapbook]
    context.call
    scrapbooks.verify
  end
end # undelete scrapbook

