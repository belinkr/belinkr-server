# encoding: utf-8
require 'minitest/autorun'
require 'redis'

require_relative '../../Factories/Entity'
require_relative '../../Factories/User'
require_relative '../../Factories/Workspace'
require_relative '../../../Cases/AutocompleteWorkspace/Request'
require_relative '../../../Services/Searcher'

$redis ||= Redis.new
$redis.select 8

include Belinkr

describe "searcher request model" do
  it "returns data objects for Searcher service" do
    payload = {'q'=> 'J'}

    searcher = Searcher.new Searcher::MemoryBackend.new "workspaces"

    searcher.store('workspaces:1', {id:1,name:"Jack Web"})
    searcher.store('workspaces:2', {id:2,name:"Tom Rad"})
    searcher.store('workspaces:3', {id:3,name:"Jerry Feb"})

    request = AutocompleteWorkspace::Request.new(
      payload, searcher, "workspaces")
    data = request.prepare 

    data.fetch(:workspaces).size.must_equal 2
    data.fetch(:workspaces).first.name.must_equal "Jack Web"
    
  end
  
end


