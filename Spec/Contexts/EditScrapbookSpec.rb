# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../App/Contexts/EditScrapbook'

include Belinkr

describe 'create scrapbook' do
  it 'applies changes to scrapbook data' do
    actor             = OpenStruct.new
    scrapbook_changes = { name: 'changed' }
    scrapbook         = Minitest::Mock.new

    context = EditScrapbook.new(
      actor:              actor, 
      scrapbook:          scrapbook, 
      scrapbook_changes:  scrapbook_changes
    )

    scrapbook.expect :authorize, scrapbook, [actor, 'update']
    scrapbook.expect :update, scrapbook, [scrapbook_changes]
    context.call
    scrapbook.verify
  end
end # create scrapbook

