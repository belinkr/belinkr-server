# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../App/Contexts/UndeleteScrapbook'
require_relative '../Doubles/Collection/Double'
require_relative '../Doubles/Scrapbook/Double'

include Belinkr

describe 'undelete scrapbook' do
  before do
    @actor      = OpenStruct.new
    @scrapbook  = Scrapbook::Double.new
    @scrapbooks = Collection::Double.new
  end

  it 'marks the scrapbook as not deleted' do
    scrapbook = Minitest::Mock.new
    context   = UndeleteScrapbook.new(
      actor:      @actor,
      scrapbook:  scrapbook, 
      scrapbooks: @scrapbooks
    )
    scrapbook.expect :authorize, scrapbook, [@actor, :undelete]
    scrapbook.expect :undelete, scrapbook
    context.call
    scrapbook.verify
  end

  it 'adds the scrapbook to own the scrapbooks collection of the actor' do
    scrapbooks  = Minitest::Mock.new
    context     = UndeleteScrapbook.new(
      actor:      @actor,
      scrapbook:  @scrapbook,
      scrapbooks: scrapbooks
    )
    scrapbooks.expect :add, scrapbooks, [@scrapbook]
    context.call
    scrapbooks.verify
  end
end # undelete scrapbook

