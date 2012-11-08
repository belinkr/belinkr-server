# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require 'redis'
require_relative '../../../Services/Locator/RedisBackend'

$redis ||= Redis.new
$redis.select 8

include Belinkr

describe User::Locator::RedisBackend do
  before do
    $redis.flushdb
    @user     = OpenStruct.new(id: 1)
    @locator  = User::Locator::RedisBackend.new
  end

  describe '#add' do
    it 'adds a key and user_id pair to the locator service' do
      @locator.add 'user@belinkr.com', @user.id
      @locator.id_for('user@belinkr.com').must_equal @user.id.to_s
      @locator.keys_for(@user.id).must_include 'user@belinkr.com'
    end
  end # add

  describe 'delete' do
    it 'deletes the user_id and all keys from the maps' do
      @locator.add 'user@belinkr.com', @user.id
      @locator.add 'user', @user.id
      @locator.keys_for(@user.id).wont_be_empty

      @locator.delete(@user.id)

      @locator.keys_for(@user.id).must_be_empty
      lambda { @locator.id_for('user@belinkr.com') }.must_raise KeyError
      lambda { @locator.id_for('user') }.must_raise KeyError
    end
  end # delete

  describe '#id_for' do
    it 'retrieves a user from a key' do
      @locator.add 'user@belinkr.com', @user.id
      @locator.id_for('user@belinkr.com').must_equal @user.id.to_s
    end

    it 'retrieves the same user if it is referenced by two different keys' do
      @locator.add 'user@belinkr.com', @user.id
      @locator.add 'user', @user.id
      
      @locator.id_for('user@belinkr.com').must_equal @locator.id_for('user')
    end
  end #id_for

  describe '#keys_for' do
    it 'returns all keys for a given user id' do
      @locator.add 'user@belinkr.com', @user.id
      @locator.add 'user', @user.id

      @locator.keys_for(@user.id).length.must_equal 2
    end

    it 'returns an empty array if no matches' do
      @locator.keys_for(@user.id).length.must_equal 0
    end
  end # keys_for

  describe 'registered?' do
    it 'returns true if user is registered in the @locator service' do
      @locator.registered?(@user.id).must_equal false
      @locator.add 'user@belinkr.com', @user.id
      @locator.registered?(@user.id).must_equal true
    end
  end #registered?

  describe 'fetch' do
    it 'returns an empty hash if no data stored' do
      @locator.fetch.must_be_instance_of Hash
    end

    it 'returns all stored records' do
      @locator.add('user@belinkr.com', 1)
      records = @locator.fetch
      records.keys.must_include 'user@belinkr.com'
      records.values.must_include '1'
      records.size.must_equal 1
    end
  end #fetch
end # User::Locator

