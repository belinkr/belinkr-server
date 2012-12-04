# encoding: utf-8
require 'minitest/autorun'
require 'redis'
require 'json'
require 'ostruct'
require_relative '../../../Cases/UndeleteScrapbook/Request'
require_relative '../../Factories/Scrapbook'

$redis ||= Redis.new
$redis.select 8

include Belinkr

describe 'request model for UndeleteScrapbook' do
  it 'prepares data objects for the context' do
    actor     = OpenStruct.new(id: 0)
    scrapbook = Factory.scrapbook(user_id: actor.id).sync

    payload = { scrapbook_id: scrapbook.id }
    payload = JSON.parse(payload.to_json)
    data    = UndeleteScrapbook::Request.new(payload, actor).prepare

    data.fetch(:actor)        .must_equal actor
    data.fetch(:enforcer)     .must_be_instance_of Scrapbook::Enforcer
    data.fetch(:scrapbook).id .must_equal scrapbook.id
    data.fetch(:scrapbooks)   .must_be_instance_of Scrapbook::Collection
  end
end # request model for UndeleteScrapbook'

