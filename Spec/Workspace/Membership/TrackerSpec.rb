# encoding: utf-8
require 'minitest/autorun'
require 'redis'
require_relative '../../../App/Workspace/Membership/Tracker'

include Belinkr::Workspace

$redis ||= Redis.new
$redis.select 8

describe Membership::Tracker do
  before do
    $redis.flushdb
    @entity_id    = 1
    @workspace_id = 2
    @tracker      = Membership::Tracker.new(@entity_id, @workspace_id)
  end

  describe '#initialize' do
    it 'requires an entity id and a workspace id' do
      lambda { Membership::Tracker.new }.must_raise ArgumentError
      lambda { Membership::Tracker.new 1 }.must_raise ArgumentError
    end
  end #initialize

  describe '#reset' do
    it 'resets the contents of the set' do
      @tracker.reset
      @tracker.add 1, 2
      @tracker.size.must_equal 1
      @tracker.reset
      @tracker.size.must_equal 0
    end

    it 'activates the memory backend' do
      @tracker.reset
      @tracker.in_memory?.must_equal true
    end

    it 'clears the backlog if no elements passed' do
      @tracker.add 1, 2
      @tracker.synced?.must_equal false
      @tracker.reset
      @tracker.synced?.must_equal true
    end

    it 'queues add operations in the backlog for passed tuples' do
      @tracker.reset
      @tracker.synced?.must_equal true
      @tracker.reset [[1, 2]]
      @tracker.synced?.must_equal false
      @tracker.size.must_equal 1
    end
  end #reset

  describe '#sync' do
    it 'clears the backlog' do
      @tracker.add 1, 2
      @tracker.synced?.must_equal false
      @tracker.sync
      @tracker.synced?.must_equal true
    end
  end #sync

  describe '#synced?' do
    it 'returns true if the backlog is empty' do
      @tracker.synced?.must_equal true
      @tracker.add 1, 2
      @tracker.synced?.must_equal false
    end
  end #synced?

  describe '#fetch' do
    it 'gets all elements from the persisted set' do
      @tracker.add 1, 2
      @tracker.sync

      @tracker.size.must_equal 1
      @tracker.reset
      @tracker.size.must_equal 0
      @tracker.fetch
      @tracker.size.must_equal 1
    end
  end #fetch

  describe '#fetched?' do
    it 'returns true if the current backend is persisted' do
      @tracker.fetched?.must_equal false
    end

    it 'returns true if the current backend is in memory' do
      @tracker.reset
      @tracker.fetched?.must_equal true
    end
  end #fetched?

  describe '#in_memory?' do
    it 'returns true if the current backend is persisted' do
      @tracker.in_memory?.must_equal false
    end

    it 'returns true if the current backend is in memory' do
      @tracker.reset
      @tracker.in_memory?.must_equal true
    end
  end #in_memory?

  describe '#add' do
    it 'adds a membership signature' do
      @tracker.reset
      @tracker.add 'administrator', 5
      @tracker.size.must_equal 1
    end

    it 'queues the operation in the backlog 
    if running on the persistent backend' do
      @tracker.reset
      @tracker.add 'administrator', 5
      @tracker.sync

      @tracker.fetch
      @tracker.size.must_equal 1
    end
  end #add

  describe '#delete' do
    it 'deletes a membership signature' do
      @tracker.reset
      @tracker.add 'administrator', 5
      @tracker.size.must_equal 1
      @tracker.delete 'administrator', 5
      @tracker.size.must_equal 0
    end

    it 'queues the operation in the backlog 
    if running on the persistent backend' do
      @tracker.reset([['administrator', 5]])
      @tracker.sync
      @tracker.fetch
      @tracker.size.must_equal 1

      @tracker.delete 'administrator', 5
      @tracker.sync
      @tracker.fetch
      @tracker.size.must_equal 0
    end
  end #delete

  describe '#each' do
    it 'instantiates a Membership::Collection for each element' do
      @tracker.reset
      @tracker.add 'administrator', 5
      memberships = @tracker.map.first
      memberships.must_be_instance_of Membership::Collection
      memberships.must_be :valid?
      memberships.kind      .must_equal 'administrator'
      memberships.user_id   .must_equal '5'
      memberships.entity_id .must_equal @entity_id.to_s
    end

    it 'fetches unless running in memory' do
      @tracker.add 1, 2
      @tracker.sync
      @tracker.map.to_a.size.must_equal 1
      @tracker.reset
      @tracker.map.to_a.size.must_equal 0
    end
  end #each
end

