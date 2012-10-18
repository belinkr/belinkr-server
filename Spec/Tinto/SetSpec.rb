require 'minitest/autorun'
require 'ostruct'
require 'redis'
require_relative '../../Tinto/Set'
require_relative '../../Tinto/Exceptions'

include Tinto::Exceptions

describe Tinto::Set do 
  $redis ||= Redis.new
  $redis.select 8

  before do
    $redis.flushdb
    @collection = OpenStruct.new(storage_key: 'test:key')
    def @collection.valid?; true; end
  end
  
  describe '#initialize' do
    it 'requires a collection and the class of this collections members' do
      set = Tinto::Set.new(@collection, OpenStruct)
      set.size.must_equal 0
    end
  end #initialize

  describe 'when resource invalid' do
    it 'raises InvalidCollection in all methods' do
      set = Tinto::Set.new(@collection, OpenStruct)

      def @collection.valid?; false; end
      lambda { set.sync       }.must_raise InvalidCollection
      lambda { set.synced?    }.must_raise InvalidCollection
      lambda { set.fetch      }.must_raise InvalidCollection
      lambda { set.reset      }.must_raise InvalidCollection
      lambda { set.each       }.must_raise InvalidCollection
      lambda { set.include? 1 }.must_raise InvalidCollection
      lambda { set.empty?     }.must_raise InvalidCollection
      lambda { set.exists?    }.must_raise InvalidCollection
      lambda { set.add 2      }.must_raise InvalidCollection
      lambda { set.delete 1   }.must_raise InvalidCollection
      lambda { set.clear      }.must_raise InvalidCollection

      def @collection.valid?; true; end
      lambda { set.each }
    end
  end #initialize

  describe '#sync' do
    it 'persists changes to the set' do
      set = Tinto::Set.new(@collection, OpenStruct)
      set.add 1
      set.sync
      set.size.must_equal 1

      set = Tinto::Set.new(@collection, OpenStruct).fetch
      set.size.must_equal 1
    end
  end #sync

  describe '#synced?' do
    it 'returns true if no backlog operations pending' do
      set = Tinto::Set.new(@collection, OpenStruct)
      set.synced?.must_equal true
      set.add 1
      set.synced?.must_equal false
      set.sync
      set.synced?.must_equal true
    end
  end

  describe '#fetch' do
    it 'populates the set with the elements stored in the DB' do
      Tinto::Set.new(@collection, OpenStruct).reset([1, 2]).sync
      set = Tinto::Set.new(@collection, OpenStruct).fetch
      set.size.must_equal 2
    end

    it 'it discards pending operations in the backlog' do
      set = Tinto::Set.new(@collection, OpenStruct).reset([1]).sync
      set.delete '1'
      set.fetch
      set.size.must_equal 1
    end
  end #fetch

  describe '#reset' do
    it 'populates the set with the passed members' do
      set = Tinto::Set.new(@collection, OpenStruct)
      set.reset(['3', '4'])
      set.map.to_a.first.id.must_equal '3'
    end

    it 'converts all passed members to string' do
      set = Tinto::Set.new(@collection, OpenStruct)
      set.reset([3, 4])
      set.map.to_a.first.id.must_equal '3'
    end

    it 'schedules the reset operation for syncing' do
      set = Tinto::Set.new(@collection, OpenStruct)
      set.synced?.must_equal true
      set.reset([3, 4])
      set.synced?.must_equal false
    end
  end #reset

  describe '#each' do
    it 'returns an enumerator if no block passed' do
      set = Tinto::Set.new(@collection, OpenStruct)
      set.each.must_be_instance_of Enumerator
    end

    it 'yields instances of the member class' do
      set = Tinto::Set.new(@collection, OpenStruct)
      set.each do |element|
        element     .must_be_instance_of OpenStruct
        element.id  .must_be_instance_of String
      end
    end
  end #each

  describe '#size' do
    it 'returns the number of elements in the set' do
      set = Tinto::Set.new(@collection, OpenStruct).reset([1, 2])
      set.size.must_equal 2
    end
  end #size

  describe '#include?' do
    it 'returns true if the set includes the id of the passed object' do
      set = Tinto::Set.new(@collection, OpenStruct).reset([1, 2])
      set.include?('3').must_equal false
      set.include?('2').must_equal true
    end
  end #include?

  describe '#empty?' do
    it 'is true if the collections has no elements' do
      set = Tinto::Set.new(@collection, OpenStruct).reset([1, 2])
      set.add 1
      set.empty?.must_equal false

      empty_set = Tinto::Set.new(@collection, OpenStruct).reset([1])
      empty_set.delete 1
      empty_set.empty?.must_equal true
    end
  end #empty?

  describe '#exists?' do
    it 'returns true if there is some element in the collection' do
      set = Tinto::Set.new(@collection, OpenStruct).reset([1])
      set.exists?.must_equal true

      collection = OpenStruct.new(storage_key: 'key:test:1')
      def collection.valid?; true; end
      empty_set = Tinto::Set.new(collection, OpenStruct).reset([1])
      empty_set.delete 1
      empty_set.exists?.must_equal false
    end
  end #exists?

  describe '#add' do
    it 'adds the id of a member to the collection, if not included yet' do
      set = Tinto::Set.new(@collection, OpenStruct).reset([1, 2])
      4.times { set.add(2) }
      set.size.must_equal 2

      set.add(3)
      set.size.must_equal 3
    end
  end #add

  describe '#delete' do
    it 'deletes an element from the collection' do
      set = Tinto::Set.new(@collection, OpenStruct).reset([1, 2])
      4.times { set.delete(5) }
      set.size.must_equal 2

      set.delete(2)
      set.size.must_equal 1
    end

  end #delete

  describe '#clear' do
    it 'removes all members' do
      set = Tinto::Set.new(@collection, OpenStruct).reset([1, 2])
      set.clear
      set.size.must_equal 0
    end
  end #clear
end # Tinto::Set

