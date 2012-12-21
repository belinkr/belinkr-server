require 'tire'
require 'minitest/autorun'
require_relative '../../../Services/Searcher/ESBackend'
include Belinkr
describe Searcher::ESBackend do
  before do
    users_index = Tire::Index.new 'test_users'
    users_index.delete
    users_index.refresh
    @backend = Searcher::ESBackend.new "test_users"

  end

  describe "#initialize" do
    it "pass a index name" do
      lambda{Searcher::ESBackend.new}.must_raise ArgumentError
    end
  end

  describe "#transform_input" do
    it "transform redis style to ES style" do
      @backend.send(:transform_input, "test_users:1", {id:1, name: 'User User'})
        .must_equal ["test_users", "test_user", id:1, name:'User User']
    end

    it "use existing type if givened in the hash" do
      @backend.send(:transform_input, "test_users:1",
        {id:1, type: 'custom_type', name: 'User User'})
        .must_equal ["test_users", "custom_type",
                     id:1, name:'User User', type: 'custom_type']

      
    end
  end
  
  describe "#transform_output" do
    it "transform ES result to redis style" do
      fake_result = [
        {"_source" => {"id"=>1, "name" => "User"}},
        {"_source" => {"id"=>2, "name" => "User2"}},
        {"_source" => {"id"=>3, "name" => "User3"}}
      ]
      @backend.send(:transform_output, fake_result).must_equal(
      {"test_users:1"=>{:id=>1, :name=>"User"}, 
       "test_users:2"=>{:id=>2, :name=>"User2"},
       "test_users:3"=>{:id=>3, :name=>"User3"}})

    end
  end

  describe "#store #autocomplete" do
    it "index document into ES" do
      @backend.store "test_users:1", {:id => 1, :cust => 'test', :name => 'tests users'}
      @backend.autocomplete("test_users", "tests").size.must_equal 1
      
    end
  end
end
 
