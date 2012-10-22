# encoding: utf-8
require 'minitest/autorun'
require 'redis'
require_relative '../../App/User/Locator'
require_relative '../../Tinto/Exceptions'
require_relative '../Factories/User'

$redis ||= Redis.new
$redis.select 8

include Belinkr::User
include Tinto::Exceptions

describe Locator do
  before do
    $redis.flushdb
    @user1 = Belinkr::Factory.user
    @user1.sync
  end

  describe '#add' do
    it 'adds a key and user_id pair to the locator service' do
      Locator.add 'user1@belinkr.com', @user1.id
      $redis.hlen(Locator::KEYS_MAP).must_equal 1
      $redis.hlen(Locator::IDS_MAP).must_equal 1
    end
  end # add

  describe '#user_from' do
    it 'retrieves a user from a key' do
      Locator.add 'user1@belinkr.com', @user1.id
      Locator.user_from('user1@belinkr.com').id.must_equal @user1.id
    end

    it 'retrieves the same user if it is referenced by two different keys' do
      Locator.add 'user1@belinkr.com', @user1.id
      Locator.add 'user1', @user1.id
      
      Locator.user_from('user1@belinkr.com').id
        .must_equal Locator.user_from('user1').id

      $redis.hlen(Locator::KEYS_MAP).must_equal 2
      $redis.hlen(Locator::IDS_MAP).must_equal 1
    end
  end # user_from

  describe '#keys_for' do
    it 'returns all keys for a given user_id' do
      Locator.add 'user1@belinkr.com', @user1.id
      Locator.add 'user1', @user1.id

      Locator.keys_for(@user1.id).length.must_equal 2
    end

    it 'returns an empty array if no matches' do
      Locator.keys_for(@user1.id).length.must_equal 0
    end
  end # keys_for

  describe 'remove' do
    it 'removes the user_id and all keys from the maps' do
      Locator.add 'user1@belinkr.com', @user1.id
      Locator.add 'user1', @user1.id
      Locator.keys_for(@user1.id).wont_be_empty

      Locator.remove(@user1.id)

      Locator.keys_for(@user1.id).must_be_empty
      lambda { Locator.user_from('user1@belinkr.com') }.must_raise NotFound
      lambda { Locator.user_from('user1') }.must_raise NotFound
    end
  end # remove

  describe 'registered?' do
    it 'returns true if user is registered in the Locator service' do
      Locator.registered?(@user1.id).must_equal false
      Locator.add 'user1@belinkr.com', @user1.id
      Locator.registered?(@user1.id).must_equal true
    end
  end
end # User::Locator

