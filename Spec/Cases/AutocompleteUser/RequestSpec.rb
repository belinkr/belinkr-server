# encoding: utf-8
require 'minitest/autorun'
require 'redis'

require_relative '../../Factories/Entity'
require_relative '../../Factories/User'
require_relative '../../Factories/Workspace'
require_relative '../../../Cases/AutocompleteUser/Request'
require_relative '../../../Services/Searcher'

$redis ||= Redis.new
$redis.select 8

include Belinkr

describe "searcher request model" do
  it "returns data objects for Searcher service" do
    payload = {'q'=> 'J'}

    searcher = Searcher.new Searcher::MemoryBackend.new "users"

    searcher.store('users:1', {id:1,name:"Jack Web"})
    searcher.store('users:2', {id:2,name:"Tom Rad"})
    searcher.store('users:3', {id:3,name:"Jerry Feb"})

    request = AutocompleteUser::Request.new(payload, searcher, "users")
    data = request.prepare 

    data.size.must_equal 2
    data.first.name.must_equal "Jack Web"
    
  end
  
end


