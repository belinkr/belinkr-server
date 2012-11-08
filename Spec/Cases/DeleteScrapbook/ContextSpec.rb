# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../../Cases/DeleteScrapbook/Context'
require_relative '../../Doubles/Scrapbook/Double'
require_relative '../../Doubles/Collection/Double'
require_relative '../../Doubles/Enforcer/Double'

include Belinkr

describe 'delete scrapbook' do 
  before do
    @enforcer   = Enforcer::Double.new  
    @actor      = OpenStruct.new
    @scrapbook  = Scrapbook::Double.new
    @scrapbooks = Collection::Double.new
  end

  it 'authorizes the actor' do
    enforcer  = Minitest::Mock.new
    context   = DeleteScrapbook::Context.new(
      enforcer:   enforcer,
      actor:      @actor, 
      scrapbook:  @scrapbook, 
      scrapbooks: @scrapbooks
    )
    
    enforcer.expect :authorize, enforcer, [@actor, 'delete']
    context.call
    enforcer.verify
  end

  it 'marks the scrapbook as deleted' do
    scrapbook = Minitest::Mock.new
    context   = DeleteScrapbook::Context.new(
      enforcer:   @enforcer,
      actor:      @actor, 
      scrapbook:  scrapbook, 
      scrapbooks: @scrapbooks
    )
    
    scrapbook.expect :delete, scrapbook
    context.call
    scrapbook.verify
  end

  it 'removes it from the own scrapbooks collection of the actor' do
    scrapbooks  = Minitest::Mock.new
    context     = DeleteScrapbook::Context.new(
      enforcer:   @enforcer,
      actor:      @actor, 
      scrapbook:  @scrapbook,
      scrapbooks: scrapbooks
    )
    scrapbooks.expect :delete, scrapbooks, [@scrapbook]
    context.call
    scrapbooks.verify
  end
end # delete scrapbook

