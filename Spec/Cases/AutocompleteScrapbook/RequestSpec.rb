# encoding: utf-8
require 'minitest/autorun'
require 'redis'

require_relative '../../Factories/Entity'
require_relative '../../Factories/User'
require_relative '../../Factories/Scrapbook'
require_relative '../../../Cases/AutocompleteScrapbook/Request'
require_relative '../../../Services/Searcher'

$redis ||= Redis.new
$redis.select 8

include Belinkr

describe "searcher request model" do
  it "returns data objects for Searcher service" do
    payload = {'q'=> 'J'}

    searcher = Searcher.new Searcher::MemoryBackend.new "scrapbooks"

    searcher.store('scrapbooks:1', {id:1, user_id:1,name:"Jack Web"})
    searcher.store('scrapbooks:2', {id:2, user_id:1,name:"Tom Rad"})
    searcher.store('scrapbooks:3', {id:3, user_id:1,name:"Jerry Feb"})

    request = AutocompleteScrapbook::Request.new(
      payload, 1, searcher, "scrapbooks")
    data = request.prepare 

    data.fetch(:scrapbooks).size.must_equal 2
    data.fetch(:scrapbooks).first.name.must_equal "Jack Web"
    
  end
  
end


