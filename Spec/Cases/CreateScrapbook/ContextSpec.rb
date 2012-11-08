# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../../Cases/CreateScrapbook/Context'
require_relative '../../Doubles/Collection/Double'
require_relative '../../Doubles/Scrapbook/Double'

include Belinkr

describe 'create scrapbook' do
  it 'links the scrapbook to the actor' do
    actor       = OpenStruct.new
    scrapbook   = Minitest::Mock.new
    scrapbooks  = Collection::Double.new

    scrapbook.expect :link_to, scrapbook, [actor]
    context = CreateScrapbook::Context.new(
      actor:      actor, 
      scrapbook:  scrapbook,
      scrapbooks: scrapbooks
    )
    context.call
    scrapbook.verify
  end

  it 'adds the scrapbook to the own scrapbook collection of the user' do
    actor      = OpenStruct.new
    scrapbook  = Scrapbook::Double.new
    scrapbooks = Minitest::Mock.new

    scrapbooks.expect :add, scrapbooks, [scrapbook]
    context = CreateScrapbook::Context.new(
      actor:      actor, 
      scrapbook:  scrapbook,
      scrapbooks: scrapbooks
    )
    context.call
    scrapbooks.verify
  end
end # create scrapbook

