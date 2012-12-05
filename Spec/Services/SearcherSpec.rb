# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../Services/Searcher'

include Belinkr

describe User::Searcher do
  before do
    @user_id = 1
    @searcher = User::Searcher.new
  end

  describe '#initialize' do
    it "init MemoryBackend" do
      @searcher.instance_variable_get('@buffered_hash')
        .must_be_instance_of User::Searcher::MemoryBackend
    end
  end #initialize

  describe "#store_user" do
    it "store key value into passed backend" do
      buffer = MiniTest::Mock.new
      searcher = User::Searcher.new(buffer: buffer)
      buffer.expect :store_user, {id:1,name:"User 1"}, ['users:1', {id:1,name:"User 1"}]
      searcher.store_user('users:1', {id:1,name:"User 1"})
      buffer.verify
    end
  end
  describe "#autocomplete" do
    it "return a list of users whose names start from given chars" do
      store_fake_users
      @searcher.autocomplete("J").size.must_equal 2
      @searcher.autocomplete("To").size.must_equal 1
      @searcher.autocomplete("Rad").size.must_equal 1
      @searcher.autocomplete("MM").size.must_equal 0
    end
  end

  def store_fake_users
    @searcher.store_user('users:1', {id:1,name:"Jack Web"})
    @searcher.store_user('users:2', {id:2,name:"Tom Rad"})
    @searcher.store_user('users:3', {id:3,name:"Jerry Feb"})
  end

end

