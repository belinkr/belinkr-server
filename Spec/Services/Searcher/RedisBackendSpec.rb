require 'minitest/autorun'
require 'redis'
require_relative '../../../Services/Searcher/RedisBackend'
include Belinkr
describe Searcher::RedisBackend do
  $redis ||= Redis.new
  $redis.select 8
  $redis.flushdb
  before  do
    @backend = Searcher::RedisBackend.new "users"
  end

  describe "#initialize" do
    it "pass an index" do
      lambda {Searcher::RedisBackend.new}.must_raise ArgumentError
    end
  end

  describe "#store and #autocomplete" do
    it "store passed user into redis db" do
      @backend.store "users:1", {id: 1, name: "User User"}
      @backend.store "users:2", {id: 2, name: "DDD CCC"}
      @backend.store "users:3", {id: 3, name: "CU CME"}
      result = @backend.autocomplete("users", "U")
      result.size.must_equal 2
      result.fetch("users:1").fetch(:name).must_equal "User User"
      

    end
    
  end

end
