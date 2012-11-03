# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../App/Contexts/CreateScrapbook'

include Belinkr

describe 'create scrapbook' do
  it 'adds the scrapbook to the own scrapbook collection of the user' do
    actor      = OpenStruct.new
    scrapbook  = OpenStruct.new
    
    scrapbooks = Minitest::Mock.new
    scrapbooks.expect :add, scrapbooks, [scrapbook]

    context = CreateScrapbook.new(
      actor:      actor, 
      scrapbook:  scrapbook,
      scrapbooks: scrapbooks
    )
    context.call
    scrapbooks.verify
  end
end # create scrapbook

