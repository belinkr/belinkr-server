# encoding: utf-8
require 'minitest/autorun'
require 'redis'
require 'json'
require 'ostruct'
require_relative '../../../Cases/EditScrapbook/Request'
require_relative '../../Factories/Scrapbook'

$redis ||= Redis.new
$redis.select 8

include Belinkr

describe 'request model for EditScrapbook' do
  it 'prepares data objects for the context' do
    actor     = OpenStruct.new(id: 0)
    scrapbook = Factory.scrapbook(user_id: actor.id).sync

    payload   = { 
                  scrapbook_id: scrapbook.id,
                  name:         'changed'
                }

    payload   = JSON.parse(payload.to_json)
    arguments = { payload: payload, actor: actor }
    data      = EditScrapbook::Request.new(arguments).prepare

    data.fetch(:actor)        .must_equal actor
    data.fetch(:enforcer)     .must_be_instance_of Scrapbook::Enforcer
    data.fetch(:scrapbook).id .must_equal scrapbook.id
    data.fetch(:scrapbook_changes).fetch('name')
      .must_equal payload.fetch('name')
  end
end # request model for EditScrapbook'

