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
    def @collection.instantiate_member(attrs={}); OpenStruct.new(attrs); end
  end
  
  describe '#initialize' do
    it 'requires a collection object' do
      lambda { Tinto::Set.new }.must_raise ArgumentError
      Tinto::Set.new OpenStruct.new
    end
  end #initialize

  describe 'when collection is invalid' do
    it 'raises InvalidCollection in all methods' do
      set = Tinto::Set.new(@collection)

      def @collection.valid?; false; end
      lambda { set.sync                           }.must_raise InvalidCollection
      lambda { set.synced?                        }.must_raise InvalidCollection
      lambda { set.fetch                          }.must_raise InvalidCollection
      lambda { set.reset                          }.must_raise InvalidCollection
      lambda { set.each                           }.must_raise InvalidCollection
      lambda { set.include? factory(id: 1)        }.must_raise InvalidCollection
      lambda { set.empty?                         }.must_raise InvalidCollection
      lambda { set.exists?                        }.must_raise InvalidCollection
      lambda { set.add factory(id: 2)             }.must_raise InvalidCollection
      lambda { set.delete factory(id: 1)          }.must_raise InvalidCollection
      lambda { set.clear                          }.must_raise InvalidCollection

      def @collection.valid?; true; end
      set.each
    end
  end #initialize

  describe '#sync' do
    it 'persists changes to the set' do
      set = Tinto::Set.new(@collection)
      set.add factory(id: 1)
      set.sync
      set.size.must_equal 1

      set = Tinto::Set.new(@collection).fetch
      set.size.must_equal 1
    end
  end #sync

  describe '#synced?' do
    it 'returns true if no backlog commands pending' do
      set = Tinto::Set.new(@collection)
      set.synced?.must_equal true
      set.add factory(id: 1)
      set.synced?.must_equal false
      set.sync
      set.synced?.must_equal true
    end
  end

  describe '#fetch' do
    it 'populates the set with the elements stored in the DB' do
      Tinto::Set.new(@collection).reset([factory(id: 1)]).sync
      set = Tinto::Set.new(@collection).fetch
      set.size.must_equal 1
    end

    it 'it discards pending commands in the backlog' do
      set = Tinto::Set.new(@collection).reset([factory(id: 1)]).sync
      set.delete factory(id: 1)
      set.fetch
      set.size.must_equal 1
    end
  end #fetch

  describe '#reset' do
    it 'populates the set with the passed members' do
      set = Tinto::Set.new(@collection)
      set.reset([factory(id: 3)])
      set.map.to_a.first.id.must_equal '3'
    end

    it 'schedules the reset command for syncing' do
      set = Tinto::Set.new(@collection)
      set.synced?.must_equal true
      set.reset([factory(id: 3)])
      set.synced?.must_equal false
    end

    it 'allows to work with the set off the database' do
      set           = Tinto::Set.new(@collection).reset
      $sync_called  = false
      def set.sync; $sync_called = true; super; end

      set.add factory(id: 55)
      set.size.must_equal 1
      $sync_called.must_equal false
      set.sync
      $sync_called.must_equal true
      set.size.must_equal 1
    end

    it 'raises unless passed an Enumerable' do
      set = Tinto::Set.new(@collection)
      lambda { set.reset(OpenStruct.new) }.must_raise ArgumentError
    end
  end #reset

  describe '#each' do
    it 'returns an enumerator if no block given' do
      set = Tinto::Set.new(@collection)
      set.each.must_be_instance_of Enumerator
    end

    it 'yields instances of the member class' do
      set = Tinto::Set.new(@collection).reset([factory(id: 1)])
      set.each do |element|
        element     .must_be_instance_of OpenStruct
        element.id  .must_be_instance_of String
      end
    end
  end #each

  describe '#size' do
    it 'returns the number of elements in the set' do
      set = Tinto::Set.new(@collection).reset([factory(id: 1)])
      set.size.must_equal 1
    end
  end #size

  describe '#empty?' do
    it 'is true if the collection has no elements' do
      set = Tinto::Set.new(@collection)
      set.add factory(id: 1)
      set.empty?.must_equal false

      empty_set = Tinto::Set.new(@collection).reset([factory(id: 1)])
      empty_set.delete factory(id: 1)
      empty_set.empty?.must_equal true
      empty_set.sync

      empty_set = Tinto::Set.new(@collection)
      empty_set.empty?.must_equal true
    end
  end #empty?

  describe '#exists?' do
    it 'returns true if there is some element in the collection' do
      set = Tinto::Set.new(@collection).reset([factory(id: 1)])
      set.exists?.must_equal true

      collection = factory(storage_key: 'key:test:1')
      def collection.valid?; true; end
      empty_set = Tinto::Set.new(collection).reset([factory(id: 1)])
      empty_set.delete factory(id: 1)
      empty_set.exists?.must_equal false
    end
  end #exists?

  describe '#include?' do
    it 'returns true if the set includes the id of the passed object' do
      set = Tinto::Set.new(@collection).reset([factory(id: 1)])
      set.include?(factory(id: 1)).must_equal true
      set.include?(factory(id: 2)).must_equal false
    end
  end #include?

  describe '#add' do
    it 'adds the id of a member to the collection, if not included yet' do
      set = Tinto::Set.new(@collection).reset([factory(id: 1)])
      4.times { set.add factory(id: 2) }
      set.size.must_equal 2

      set.add(factory(id: 3))
      set.size.must_equal 3
    end

    it 'raises InvalidMember if element is not valid' do
      set     = Tinto::Set.new(@collection)
      element = factory(id: 5)

      def element.valid?; false; end
      lambda { set.add(element) }.must_raise InvalidMember
    end
  end #add

  describe '#delete' do
    it 'deletes an element from the collection' do
      set = Tinto::Set.new(@collection).reset([factory(id: 1)])
      4.times { set.delete(factory(id: 5)) }
      set.size.must_equal 1

      set.delete(factory(id: 1))
      set.size.must_equal 0
    end

    it 'raises InvalidMember if element is not valid' do
      set     = Tinto::Set.new(@collection)
      element = factory(id: 5)

      def element.valid?; false; end
      lambda { set.delete(element) }.must_raise InvalidMember
    end
  end #delete

  describe '#clear' do
    it 'removes all members' do
      set = Tinto::Set.new(@collection).reset([factory(id: 1)])
      set.clear
      set.size.must_equal 0
    end
  end #clear

  def factory(attrs={})
    member = OpenStruct.new(attrs)
    def member.valid?; true; end
    member
  end
end # Tinto::Set

