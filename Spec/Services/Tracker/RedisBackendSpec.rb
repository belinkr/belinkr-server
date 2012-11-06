# encoding: utf-8
require 'minitest/autorun'
require 'redis'
require_relative '../../../App/Services/Tracker/RedisBackend'

include Belinkr

describe Workspace::Tracker::RedisBackend do
  $redis ||= Redis.new
  $redis.select 8

  before do
    $redis.flushdb
    @tracker = Workspace::Tracker::RedisBackend.new('test')
  end

  describe '#initialize' do
    it 'requires a storage key' do
      lambda { Workspace::Tracker::RedisBackend.new }.must_raise ArgumentError
    end
  end #initialize

  describe '#add' do
    it 'adds an element to the set' do
      @tracker.add 'administrator:5'
      @tracker.size.must_equal 1
    end
  end #add

  describe '#delete' do
    it 'deletes an element from the set' do
      @tracker.add 'administrator:5'
      @tracker.size.must_equal 1
      @tracker.delete 'administrator:5'
      @tracker.size.must_equal 0
    end
  end #delete

  describe '#fetch' do
    it 'returns all elements in the set' do
      @tracker.add 'administrator:5'
      @tracker.add 'collaborator:6'
      @tracker.fetch.must_include 'administrator:5'
      @tracker.fetch.must_include 'collaborator:6'
    end
  end #fetch

  describe '#size' do
    it 'returns the size of the set' do
      @tracker.add 'administrator:5'
      @tracker.size.must_equal 1
    end
  end #size
end # Workspace::Tracker::RedisBackend

