require 'minitest/autorun'
require 'ostruct'
require 'redis'
require_relative '../../Tinto/SortedSet'
require_relative '../../Tinto/Exceptions'

include Tinto::Exceptions

describe Tinto::SortedSet do
  $redis ||= Redis.new
  $redis.select 8

  before do
    $redis.flushdb
    @collection = OpenStruct.new(storage_key: 'test:key')
    def @collection.valid?; true; end
    def @collection.instantiate_member(attrs={}); OpenStruct.new(attrs) ; end
  end

  describe '#initialize' do
    it 'requires a collection object' do
      lambda { Tinto::SortedSet.new }.must_raise ArgumentError
      Tinto::SortedSet.new OpenStruct.new
    end
  end #initialize

  describe 'when collection is invalid' do
    it 'raises InvalidCollection in all methods' do
      zset = Tinto::SortedSet.new(@collection)

      def @collection.valid?; false; end
      lambda { zset.each }.must_raise InvalidCollection

      def @collection.valid?; true; end
      zset.each
    end
  end # when collection is invalid

  describe '#sync' do
    it 'persists changes to the set' do
      zset = Tinto::SortedSet.new(@collection)
      zset.add factory(id: 1)
      zset.sync
      zset.size.must_equal 1

      zset = Tinto::SortedSet.new(@collection).fetch
      zset.size.must_equal 1
    end
  end #sync

  describe '#synced?' do
    it 'returns true if no backlog commands pending' do
      zset = Tinto::SortedSet.new(@collection)
      zset.synced?.must_equal true
      zset.add factory(id: 1)
      zset.synced?.must_equal false
      zset.sync
      zset.synced?.must_equal true
    end
  end #synced?

  describe '#fetch' do
    it 'loads all records from db' do
      elements  = (1..100).map { |i| factory(id: i) }
      zset      = Tinto::SortedSet.new(@collection).reset(elements)
      zset.sync

      zset      = Tinto::SortedSet.new(@collection).fetch

      def $redis.zcard(*args); $redis_called = true; super *args; end
      $redis_called = false
      zset.size.must_equal 100
      $redis_called.must_equal false
    end
  end #fetch

  describe '#page' do
    it 'loads a page of records' do
      elements  = (1..100).map { |i| factory(id: i) }
      zset      = Tinto::SortedSet.new(@collection).reset(elements)
      zset.sync

      zset      = Tinto::SortedSet.new(@collection).page

      def $redis.zcard(*args); $redis_called = true; super *args; end
      $redis_called = false
      zset.size.must_equal 20
      $redis_called.must_equal false
    end

    it 'appends the records to previously loaded ones' do
      elements  = (1..100).map { |i| factory(id: i) }
      zset      = Tinto::SortedSet.new(@collection).reset(elements)
      zset.sync

      zset      = Tinto::SortedSet.new(@collection).page
      zset.size.must_equal 20
      zset.page(1)
      zset.size.must_equal 40
      zset.page(2)
      zset.size.must_equal 60
    end

    it 'loads the highest scored records first' do
      elements  = (1..100).map { |i| factory(id: i) }
      zset      = Tinto::SortedSet.new(@collection).reset(elements)
      zset.sync

      zset      = Tinto::SortedSet.new(@collection)
      zset.page
      last_score_in_first_page    = zset.score(zset.to_a[19])

      zset.page(1)
      first_score_in_second_page  = zset.score(zset.to_a[20])

      (last_score_in_first_page > first_score_in_second_page).must_equal true
    end
  end #page

  describe '#reset' do
    it 'populates the set with the passed members' do
      zset = Tinto::SortedSet.new(@collection)
      zset.reset([factory(id: 3)])
      zset.map.to_a.first.id.must_equal '3'
    end

    it 'schedules the reset command for syncing' do
      zset = Tinto::SortedSet.new(@collection)
      zset.synced?.must_equal true
      zset.reset([factory(id: 3)])
      zset.synced?.must_equal false
    end

    it 'allows to work with the zset off the database' do
      zset          = Tinto::SortedSet.new(@collection).reset
      $sync_called  = false
      def zset.sync; $sync_called = true; super; end

      zset.add factory(id: 55)
      zset.size.must_equal 1
      $sync_called.must_equal false
      zset.sync
      $sync_called.must_equal true
      zset.size.must_equal 1
    end

    it 'raises unless passed an Enumerable' do
      zset = Tinto::SortedSet.new(@collection)
      lambda { zset.reset(OpenStruct.new) }.must_raise ArgumentError
    end
  end #reset

  describe '#each' do
    it 'returns an enumerator if no block given' do
      zset = Tinto::SortedSet.new(@collection)
      zset.each.must_be_instance_of Enumerator
    end

    it 'yields instances of the member class' do
      zset = Tinto::SortedSet.new(@collection).reset([factory(id: 1)])
      zset.each do |element|
        element     .must_be_instance_of OpenStruct
        element.id  .must_be_instance_of String
      end
    end
  end #each 

  describe '#size' do
    it 'returns the number of elements in the set' do
      zset = Tinto::SortedSet.new(@collection).reset([factory(id: 1)])
      zset.size.must_equal 1
    end
  end #size

  describe '#empty?' do
    it 'is true if the collection has no elements' do
      zset = Tinto::SortedSet.new(@collection)
      zset.add factory(id: 1)
      zset.empty?.must_equal false

      empty_zset = Tinto::SortedSet.new(@collection).reset([factory(id: 1)])
      empty_zset.delete factory(id: 1)
      empty_zset.empty?.must_equal true
      empty_zset.sync

      empty_zset = Tinto::SortedSet.new(@collection)
      empty_zset.empty?.must_equal true
    end
  end #empty?

  describe '#exists?' do
    it 'returns true if there is some element in the collection' do
      zset = Tinto::SortedSet.new(@collection).reset([factory(id: 1)])
      zset.exists?.must_equal true

      collection = factory(storage_key: 'key:test:1')
      def collection.valid?; true; end
      empty_zset = Tinto::SortedSet.new(collection).reset([factory(id: 1)])
      empty_zset.delete factory(id: 1)
      empty_zset.exists?.must_equal false
    end
  end #exists?

  describe '#include?' do
    it 'returns true if the set includes the id of the passed object' do
      zset = Tinto::SortedSet.new(@collection).reset([factory(id: 1)])
      zset.include?(factory(id: 1)).must_equal true
      zset.include?(factory(id: 2)).must_equal false
    end
  end #include?

  describe '#add' do
    it 'adds the id of a member to the collection, if not included yet' do
      zset = Tinto::SortedSet.new(@collection).reset([factory(id: 1)])
      4.times { zset.add factory(id: 2) }
      zset.size.must_equal 2

      zset.add factory(id: 3)
      zset.size.must_equal 3
    end

    it 'sets the score as the updated_at field of the passed member' do
      zset    = Tinto::SortedSet.new(@collection).reset([factory(id: 1)])
      element = factory(id: 1)
      zset.add element
      zset.score(element).must_equal element.updated_at.to_f
    end

    it 'updates the score of an existing element' do
      element             = factory(id: 1)
      zset                = Tinto::SortedSet.new(@collection).reset([element])
      previous_score      = zset.score(element)
      element.updated_at  = Time.now

      zset.add(element)
      (zset.score(element) > previous_score).must_equal true
    end
  end #add

  describe '#delete' do
    it 'removes an element from the collection' do
      element = factory(id: 1)
      zset    = Tinto::SortedSet.new(@collection).reset([element])
      4.times { zset.delete(factory(id: 5)) }
      zset.size.must_equal 1

      zset.delete(factory(id: 1))
      zset.size.must_equal 0
      zset.score(element).must_equal Tinto::SortedSet::NOT_IN_SET_SCORE
    end

    it 'raises InvalidMember if element is not valid' do
      zset     = Tinto::SortedSet.new(@collection)
      element = factory(id: 5)

      def element.valid?; false; end
      lambda { zset.delete(element) }.must_raise InvalidMember
    end
  end #delete

  describe '#clear' do
    it 'removes all members' do
      element = factory(id: 1)
      zset    = Tinto::SortedSet.new(@collection).reset([element])
      zset.clear
      zset.size.must_equal 0
      zset.score(element).must_equal Tinto::SortedSet::NOT_IN_SET_SCORE
    end
  end #clear

  describe 'score' do
    it 'gets the score of an element' do
      element = factory(id: 1)
      zset    = Tinto::SortedSet.new(@collection).reset([element])
      zset.score(element).must_equal element.updated_at.to_f
    end
  end

  def factory(attributes={})
    attributes  = { updated_at: Time.now }.merge!(attributes)
    member      = OpenStruct.new(attributes)
    def member.valid?; true; end
    member
  end
end
