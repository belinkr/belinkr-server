require 'minitest/autorun'
require_relative '../../../Services/Searcher/ESBackend'
include Belinkr
describe Searcher::ESBackend do
  before do
    @backend = Searcher::ESBackend.new "users"
  end

  describe "#initialize" do
    it "pass a index name" do
      lambda{Searcher::ESBackend.new}.must_raise ArgumentError
    end
  end

  describe "#transform_input" do
    it "transform redis style to ES style" do
      @backend.send(:transform_input, "users:1", {id:1, name: 'User User'})
        .must_equal ["users", id:1, name:'User User']
    end
  end
  
  describe "#transform_output" do
    it "transform ES result to redis style" do
      fake_result = [
        {"_source" => {"id"=>1, "name" => "User"}},
        {"_source" => {"id"=>2, "name" => "User2"}},
        {"_source" => {"id"=>3, "name" => "User3"}}
      ]
      puts @backend.send(:transform_output, fake_result).must_equal(
      {"users:1"=>{:id=>1, :name=>"User"}, 
       "users:2"=>{:id=>2, :name=>"User2"},
       "users:3"=>{:id=>3, :name=>"User3"}})

    end
  end
end
 
