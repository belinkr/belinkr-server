# encoding: utf-8
require 'redis'
require 'json'
require 'minitest/autorun'
require_relative '../../Tinto/SortedSet'
require_relative '../../Tinto/Exceptions'

$redis = Redis.new
$redis.select 8

dummy = Class.new do 
  attr_reader :attributes, :score
  alias_method :to_hash, :attributes
  def initialize(attrs={}); 
    @attributes = attrs;
    @score = Time.now.to_f;
  end
  def id; @attributes[:id]; end
  def to_json; @attributes.to_json; end
end

describe Tinto::SortedSet do
  before do
    $redis.flushdb
    resource  = Class.new { def valid?; true; end }.new
    @zset     = Tinto::SortedSet.new(resource, dummy, 'dummy:sorted_set')
  end

  describe '#initialize' do
    it 'requires a storage_key and the class of this collection members' do
      lambda { Tinto::SortedSet.new }.must_raise ArgumentError
      lambda { Tinto::SortedSet.new 'dummy:sorted_set' }
        .must_raise ArgumentError
    end
  end #initialize

  describe 'when resource invalid' do
    it 'all methods raise Tinto::Exceptions::InvalidResource' do
      resource = Class.new { def valid?; false; end }.new
      zset     = Tinto::SortedSet.new(resource, dummy, 'dummy:sorted_set')

      proc { zset.each         }.must_raise Tinto::Exceptions::InvalidResource
      proc { zset.size         }.must_raise Tinto::Exceptions::InvalidResource
      proc { zset.include? 'a' }.must_raise Tinto::Exceptions::InvalidResource
      proc { zset.empty?       }.must_raise Tinto::Exceptions::InvalidResource
      proc { zset.exists?      }.must_raise Tinto::Exceptions::InvalidResource
      proc { zset.all          }.must_raise Tinto::Exceptions::InvalidResource
      proc { zset.page         }.must_raise Tinto::Exceptions::InvalidResource
      proc { zset.merge([])    }.must_raise Tinto::Exceptions::InvalidResource
      proc { zset.add 'foo'    }.must_raise Tinto::Exceptions::InvalidResource
      proc { zset.remove 'foo' }.must_raise Tinto::Exceptions::InvalidResource
      proc { zset.score 'a', 1 }.must_raise Tinto::Exceptions::InvalidResource
    end
  end # when resource invalid

  describe '#each' do
    it 'yields instances of the member_class, deserialized from @members' do
      @zset.add dummy.new(id: 1, name: 'dummy')
      @zset.all.to_a.first.must_be_instance_of dummy
    end

    it 'if the collection implements #member_init_params, it instantiates
    the member with the id and the returned hash from #member_init_params' do
      resource  = Class.new { 
                    def valid?; true; end 
                    def member_init_params; { entity_id: 1 }; end
                  }.new
      zset     = Tinto::SortedSet.new(resource, dummy, 'dummy:sorted_set')
      zset.add dummy.new(id: 1, name: 'dummy')
      zset.all.first.attributes.has_key?(:entity_id).must_equal true
    end
  end # each

  describe '#size' do
    it 'returns the number of elements in the collection' do
      @zset.size.must_equal 0
      @zset.add dummy.new(id: 1, name: 'a')
      @zset.size.must_equal 1
      @zset.length.must_equal 1
    end
  end #size

  describe '#include?' do
    it 'returns true if the set includes the id of the passed object' do
      item = dummy.new(id: 1, name: 'a')
      @zset.must_be_empty
      @zset.include?(item).must_equal false
      @zset.add item
      @zset.include?(item).must_equal true
      @zset.remove item
      @zset.include?(item).must_equal false
    end
  end #include?

  describe '#empty?' do
    it 'is true if collection has no elements' do
      @zset.empty?.must_equal true
      @zset.add dummy.new(id: 1, name: 'a')
      @zset.empty?.must_equal false
      @zset.remove dummy.new(id: 1, name: 'a')
      @zset.empty?.must_equal true
    end
  end #empty?

  describe '#exists?' do
    it 'returns true if there is some element in the collection' do
      @zset.exists?.must_equal false
      @zset.add dummy.new(id: 1, name: 'a')
      @zset.exists?.must_equal true
    end
  end #exists?

  describe '#all' do
    it 'retrieves all records' do
      50.times { |i| @zset.add dummy.new(id: i, text: 'test #{i}') }
      @zset.size.must_equal 50
      @zset.all.size.must_equal 50
    end
  end #all

  describe '#page' do
    it 'retrieves a page of records' do
      skip
      @zset.add dummy.new(id: 1, text: 'status 1', user_id: 1)
      @zset.add dummy.new(id: 2, text: 'status 2', user_id: 2)

      @zset.page(0).size.must_equal 2
      @zset.page(1).size.must_equal 0

      20.times { |i| 
        @zset.add dummy.new(
          id: i + 5, text: 'status #{i + 5}', user_id: i + 5 
        )
      }

      @zset.page(0).size.must_equal 20
      @zset.page(1).size.must_equal 2
    end

    it 'accepts page numbers as strings' do
      skip
      @zset.add dummy.new(id: 1, text: 'status 1', user_id: 1)
      @zset.add dummy.new(id: 2, text: 'status 2', user_id: 2)

      @zset.page('0').size.must_equal 2
    end
  end #page

  describe '#merge' do
    it 'adds the objects in the passed enumerable' do
      @zset.empty?.must_equal true
      @zset.merge [dummy.new(id: 1, name: 'a'), dummy.new(id: 2, name: 'b') ]
      @zset.size.must_equal 2
    end
  end #merge

  describe '#add' do
    it 'adds the id of a member to the collection, if not present yet' do
      @zset.empty?.must_equal true
      @zset.add dummy.new(id: 1, name: 'a')
      @zset.empty?.must_equal false
      @zset << dummy.new(id: 1, name: 'a')
      @zset.size.must_equal 1 
      @zset << dummy.new(id: 2, name: 'b')
      @zset.size.must_equal 2
    end

    it 'sets the score to the passed score if available' do
      @zset.empty?.must_equal true
      resource = dummy.new(id: 1, name: 'a')
      @zset.add resource, 57
      $redis.zscore('dummy:sorted_set', resource.id).to_i.must_equal 57
    end
  end #add

  describe '#remove' do
    it 'removes an element from the collection' do
      @zset.empty?.must_equal true
      @zset.add dummy.new(id: 1, name: 'a')
      @zset.empty?.must_equal false
      @zset.remove dummy.new(id: 1, name: 'a')
      @zset.empty?.must_equal true
    end
  end #remove

  describe '#delete' do
    it 'deletes the collection' do
      @zset.add dummy.new(id: 1, name: 'a')
      @zset.empty?.must_equal false
      @zset.delete
      @zset.empty?.must_equal true
      @zset.exists?.must_equal false
    end
  end #delete

  describe '#score' do
    it 'updates the score for an element of the collection' do
      dummy1 = dummy.new(id: 1, name: 'a')
      old_score = dummy1.score
      @zset.add dummy1 

      new_score = Time.now.to_f
      @zset.score dummy1, new_score

      $redis.zscore('dummy:sorted_set', dummy1.id).to_f.must_equal new_score
      ($redis.zscore('dummy:sorted_set', dummy1.id).to_f > old_score)
        .must_equal true
    end
  end #score
end # Tinto::SortedSet
