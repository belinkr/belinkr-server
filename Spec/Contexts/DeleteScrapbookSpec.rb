# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../App/Contexts/DeleteScrapbook'
require_relative '../Doubles/Scrapbook/Double'
require_relative '../Doubles/Collection/Double'

include Belinkr

describe 'delete scrapbook' do 
  before do
    @actor       = OpenStruct.new
    @scrapbook   = Scrapbook::Double.new
    @scrapbooks  = Collection::Double.new
  end

  it 'marks the scrapbook as deleted' do
    scrapbook = Minitest::Mock.new
    context   = DeleteScrapbook.new(
      actor:      @actor, 
      scrapbook:  scrapbook, 
      scrapbooks: @scrapbooks
    )
    
    scrapbook.expect :authorize, scrapbook, [@actor, 'delete']
    scrapbook.expect :delete, scrapbook
    context.call
    scrapbook.verify
  end

  it 'removes it from the own scrapbooks collection of the actor' do
    scrapbooks  = Minitest::Mock.new
    context     = DeleteScrapbook.new(
      actor:      @actor, 
      scrapbook:  @scrapbook,
      scrapbooks: scrapbooks
    )
    scrapbooks.expect :delete, scrapbooks, [@scrapbook]
    context.call
    scrapbooks.verify
  end
end # delete scrapbook

