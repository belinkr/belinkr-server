# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require 'redis'
require_relative '../../Services/Locator'

$redis ||= Redis.new
$redis.select 8

include Belinkr

describe User::Locator do
  before do 
    $redis.flushdb
    @user = OpenStruct.new(id: 1)
  end

  describe '#add' do
    it 'delegates to the buffer backend' do
      buffer  = fake.new
      locator = User::Locator.new(buffer: buffer)
      locator.add('user1@belinkr.com', @user)
      buffer.called?.must_equal true
    end

    it 'adds an operation to the backlog of the persistence backend' do
      locator = User::Locator.new
      locator.synced?.must_equal true
      locator.add('user1@belinkr.com', @user)
      locator.synced?.must_equal false
    end
  end

  describe '#delete' do
    it 'delegates to the buffer backend' do
      buffer  = fake.new
      locator = User::Locator.new(buffer: buffer)
      locator.delete('user1@belinkr.com')
      buffer.called?.must_equal true
    end

    it 'adds an operation to the backlog of the persistence backend' do
      buffer  = fake.new
      locator = User::Locator.new(buffer: buffer)
      locator.synced?.must_equal true
      locator.delete('user1@belinkr.com')
      locator.synced?.must_equal false
    end
  end #delete

  describe 'id_for' do
    it 'delegates to buffer backend if data fetched' do
      buffer, backend = fake.new, fake.new
      locator = User::Locator.new(buffer: buffer, backend: backend)
      locator.fetch
      locator.id_for('user1@belinkr.com')
      buffer.called?.must_equal true
      backend.called?.must_equal false
    end

    it 'delegates to persistence backend if data not fetched' do
      buffer, backend = fake.new, fake.new
      locator = User::Locator.new(buffer: buffer, backend: backend)
      locator.id_for('user1@belinkr.com')
      buffer.called?.must_equal false
      backend.called?.must_equal true
    end
  end #id_for

  describe 'keys_for' do
    it 'delegates to buffer backend if data fetched' do
      buffer, backend = fake.new, fake.new
      locator = User::Locator.new(buffer: buffer, backend: backend)
      locator.fetch
      locator.keys_for(1)
      buffer.called?.must_equal true
      backend.called?.must_equal false
    end

    it 'delegates to persistence backend if data not fetched' do
      buffer, backend = fake.new, fake.new
      locator = User::Locator.new(buffer: buffer, backend: backend)
      locator.keys_for(1)
      buffer.called?.must_equal false
      backend.called?.must_equal true
    end
  end #keys_for

  describe 'registered?' do
    it 'delegates to buffer backend if data fetched' do
      buffer, backend = fake.new, fake.new
      locator = User::Locator.new(buffer: buffer, backend: backend)
      locator.fetch
      locator.registered?('user1@belinkr.com')
      buffer.called?.must_equal true
      backend.called?.must_equal false
    end

    it 'delegates to persistence backend if data not fetched' do
      buffer, backend = fake.new, fake.new
      locator = User::Locator.new(buffer: buffer, backend: backend)
      locator.registered?('user1@belinkr.com')
      buffer.called?.must_equal false
      backend.called?.must_equal true
    end
  end #registered?

  describe '#synced?' do
    it 'returns true if no operations pending' do
      locator = User::Locator.new
      locator.synced?.must_equal true
    end

    it 'returns false if there are pendingn persistence operations' do
      locator = User::Locator.new
      locator.add('user1@belinkr.com', @user)
      locator.synced?.must_equal false
    end
  end #synced?

  describe '#sync' do
    it 'executes pending operations on the backend' do
      backend = fake.new
      locator = User::Locator.new(backend: backend)
      locator.add('user1@belinkr.com', @user)
      locator.sync
      backend.called?.must_equal true
    end

    it 'transitions to a synced state' do
      locator = User::Locator.new
      locator.add('user1@belinkr.com', @user)
      locator.synced?.must_equal false
      locator.sync
      locator.synced?.must_equal true
    end
  end #sync

  describe '#fetched?' do
    it 'returns true if data fetched' do
      locator = User::Locator.new
      locator.fetched?.must_equal false
      locator.fetch
      locator.fetched?.must_equal true

      locator = User::Locator.new
      locator.fetched?.must_equal false
      locator.reset([])
      locator.fetched?.must_equal true
    end

    it 'returns false if no data previously fetched' do
      locator = User::Locator.new
      locator.fetched?.must_equal false
    end
  end #fetched?

  describe '#fetch' do
    it 'discards pending operations in the backlog' do
      buffer, backend = fake.new, fake.new
      locator = User::Locator.new(buffer: buffer, backend: backend)
      locator.add('user1@belinkr.com', @user)
      locator.fetch
      backend.called?.must_equal false
    end

    it 'transitions to a synced state' do
      locator = User::Locator.new
      locator.fetch
      locator.synced?.must_equal true
    end

    it 'transitions to a fetched state' do
      locator = User::Locator.new
      locator.fetch
      locator.fetched?.must_equal true
    end

    it 'delegates to the persisted backend' do
      locator = User::Locator.new
      locator.add('user1@belinkr.com', @user.id)
      locator.sync

      locator = User::Locator.new
      locator.fetch
      locator.id_for('user1@belinkr.com').must_equal @user.id.to_s
    end
  end #fetch

  describe '#reset' do
    it 'transitions to a synced state if reset with no data' do
      locator = User::Locator.new
      locator.reset
      locator.synced?.must_equal true
    end

    it 'transitions to an unsynced state if reset with some data' do
      locator = User::Locator.new
      locator.synced?.must_equal true
      locator.reset([['foo', 1]])
      locator.synced?.must_equal false
    end

    it 'transitions to a fetched state' do
      locator = User::Locator.new
      locator.reset([['foo', 1]])
      locator.synced?.must_equal false
      locator.fetched?.must_equal true  

      locator = User::Locator.new
      locator.reset
      locator.fetched?.must_equal true  
    end
  end #reset

  def fake
    Class.new { 
      def called?;            !!@called; end
      def add(*args);         @called = true; end 
      def delete(*args);      @called = true; end 
      def id_for(*args);      @called = true; end 
      def keys_for(*args);    @called = true; end 
      def registered?(*args); @called = true; end 
      def fetch(*args);       []; end 
    }
  end
end # User::Locator

