# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../App/Contexts/EditScrapbook'
require_relative '../Doubles/Enforcer/Double'
require_relative '../Doubles/Scrapbook/Double'

include Belinkr

describe 'edit scrapbook' do
  it 'authorizes the actor' do
    enforcer          = Minitest::Mock.new
    actor             = OpenStruct.new
    scrapbook_changes = { name: 'changed' }
    scrapbook         = Scrapbook::Double.new

    context = EditScrapbook.new(
      enforcer:           enforcer,
      actor:              actor, 
      scrapbook:          scrapbook, 
      scrapbook_changes:  scrapbook_changes
    )
    enforcer.expect :authorize, scrapbook, [actor, 'update']
    context.call
    enforcer.verify
  end

  it 'applies changes to scrapbook data' do
    enforcer          = Enforcer::Double.new
    actor             = OpenStruct.new
    scrapbook_changes = { name: 'changed' }
    scrapbook         = Minitest::Mock.new

    context = EditScrapbook.new(
      enforcer:           enforcer,
      actor:              actor, 
      scrapbook:          scrapbook, 
      scrapbook_changes:  scrapbook_changes
    )
    scrapbook.expect :update, scrapbook, [scrapbook_changes]
    context.call
    scrapbook.verify
  end
end # edit scrapbook

