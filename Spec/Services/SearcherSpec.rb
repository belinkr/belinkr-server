# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../Services/Searcher'

include Belinkr

describe Searcher do
  before do
    @searcher = Searcher.new Searcher::MemoryBackend.new "users"
    @es_searcher = Searcher.new Searcher::ESBackend.new "users"
  end

  describe '#initialize' do
    it "init MemoryBackend" do
      @searcher.backend.must_be_instance_of Searcher::MemoryBackend
    end

    it "init passed ESBackend" do
      @es_searcher.backend.must_be_instance_of Searcher::ESBackend
    end

    it "raise if no backend pass" do
      lambda{Searcher.new}.must_raise ArgumentError
    end
  end #initialize

  describe "#store_user" do
    it "store key value into passed backend" do
      buffer = MiniTest::Mock.new
      searcher = Searcher.new(buffer)
      buffer.expect :store_user, {id:1,name:"User 1"},
        ['users:1', {id:1,name:"User 1"}]
      searcher.store_user('users:1', {id:1,name:"User 1"})
      buffer.verify
    end
  end

  describe "#autocomplete" do
    it "return a list of users whose names start from given chars" do
      store_fake_users
      @searcher.autocomplete("users", "J").size.must_equal 2
      @searcher.autocomplete("users", "To").size.must_equal 1
      @searcher.autocomplete("users", "Rad").size.must_equal 1
      @searcher.autocomplete("users", "MM").size.must_equal 0
      @searcher.autocomplete("users", "Rad").fetch("users:2").fetch(:name)
        .must_equal "Tom Rad"
    end

    it "#store then search user in ESBackend" do
      es_store_fake_users
      @es_searcher.autocomplete("users","J").size.must_equal 2
      @es_searcher.autocomplete("users","J").fetch("users:1")
        .must_equal({id: 1, name:"Jack Web"})
    end

  end

  def store_fake_users
    @searcher.store_user('users:1', {id:1,name:"Jack Web"})
    @searcher.store_user('users:2', {id:2,name:"Tom Rad"})
    @searcher.store_user('users:3', {id:3,name:"Jerry Feb"})
  end
  def es_store_fake_users
    @es_searcher.store_user('users:1', {id:1,name:"Jack Web"})
    @es_searcher.store_user('users:2', {id:2,name:"Tom Rad"})
    @es_searcher.store_user('users:3', {id:3,name:"Jerry Feb"})
  end


end

