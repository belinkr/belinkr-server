require 'minitest/autorun'
require_relative '../../../Services/Searcher/MemoryBackend'
include Belinkr::User
describe Searcher do
  before  do
    @backend = Searcher::MemoryBackend.new
  end

  describe "#initialize" do
    it "assign a users instance variable" do
      @backend.users.wont_be_nil
    end
  end

  describe "#store_user" do
    it "save key and value to users hash" do
      @backend.store_user("users:1", {id: 1, name: "User User"})
      @backend.users.must_equal({"users:1" => {id:1, name: "User User"}})
    end

    it "require passed key and value" do
      lambda { @backend.store_user "only key" }.must_raise ArgumentError
    end
  end

  describe "#autocomplete" do
    it "returns matched users" do
      @backend.store_user("users:1", {id: 1, name: "Cindy User"})
      @backend.store_user("users:2", {id: 2, name: "Kate User"})
      @backend.store_user("users:3", {id: 3, name: "DDD One"})
      @backend.autocomplete("User").must_equal({
        "users:1" => {id: 1, name: "Cindy User"},
        "users:2" => {id: 2, name: "Kate User"}
      })
    end
  end
  
end
