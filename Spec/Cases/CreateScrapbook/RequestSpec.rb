# encoding: utf-8
require 'minitest/autorun'
require 'json'
require 'ostruct'
require_relative '../../../Cases/CreateScrapbook/Request'

include Belinkr

describe 'request model for CreateScrapbook' do
  it 'prepares data objects for the context' do
    actor     = OpenStruct.new(id: 0)
    arguments = { payload: {}, actor: actor }
    data      = CreateScrapbook::Request.new(arguments).prepare

    data.fetch(:actor)        .must_equal actor
    data.fetch(:scrapbook)    .must_be_instance_of Scrapbook::Member
    data.fetch(:scrapbooks)   .must_be_instance_of Scrapbook::Collection
  end
end # request model for CreateScrapbook'

