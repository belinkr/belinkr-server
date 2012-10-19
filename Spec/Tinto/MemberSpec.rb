# encoding: utf-8
require 'minitest/autorun'
require 'redis'
require 'ostruct'
require_relative '../../Tinto/Exceptions'
require_relative '../../Tinto/Member'

include Tinto::Exceptions

describe Tinto::Member do
  $redis ||= Redis.new
  $redis.select 8

  before do
    $redis.flushdb
  end

  describe '#initialize' do
    it 'requires a member resource' do
      lambda { Tinto::Member.new }.must_raise ArgumentError
      Tinto::Member.new OpenStruct.new
    end

    it 'sets a default value for the created_at attribute of the resource' do
      resource  = OpenStruct.new
      member    = Tinto::Member.new resource

      resource.created_at.wont_be_nil
    end

    it 'sets a default value for the updated_at attribute of the resource' do
      member = Tinto::Member.new OpenStruct.new
      (member.score > 0.0).must_equal true
    end

    it 'accepts a default context for validation' do
      resource  = OpenStruct.new
      def resource.valid?(context=nil); context == 'workspace'; end

      member    = Tinto::Member.new resource, 'foo'
      member.valid?.must_equal false

      member    = Tinto::Member.new resource, 'workspace'
      member.valid?.must_equal true
    end
  end #initialize

  describe 'valid?' do
    it 'returns true if resource valid' do
      resource  = OpenStruct.new
      member    = Tinto::Member.new resource, 'foo'

      def resource.valid?(*args); false; end
      member.valid?.must_equal false

      def resource.valid?(*args); true; end
      member.valid?.must_equal true
    end

    it 'validates in context if passed at initialization' do
      resource  = OpenStruct.new
      def resource.valid?(context=nil); context =='workspace'; end

      member    = Tinto::Member.new resource, 'foo'
      member.valid?.must_equal false

      member    = Tinto::Member.new resource, 'workspace'
      member.valid?.must_equal true
    end
  end #valid?

  describe '#attributes' do
    it 'delegates to the member resource attributes' do
      resource1 = factory(id:1, name: 'member 1')
      member1   = Tinto::Member.new resource1

      resource1.attributes.must_equal member1.attributes
    end
  end #attributes

  describe '#==' do
    it 'compares the #attributes values of the resource' do
      member1 = Tinto::Member.new factory(id: 1, name: 'member 1')
      member2 = Tinto::Member.new factory(id: 1, name: 'member 1')
      member1.must_equal member2
    end
  end #==

  describe '#score' do
    it 'returns the float value of the updated_at attribute' do
      just_now  = Time.now
      member    = Tinto::Member.new factory(id:1, updated_at: just_now)

      member.score.must_equal just_now.to_f
    end

    it 'returns -1.0 if resource has no updated_at attribute' do
      resource  = factory(id: 1)
      member    = Tinto::Member.new resource
      resource.updated_at = nil
      member.score.must_equal Tinto::Member::NO_SCORE_VALUE
    end
  end #score

  describe '#to_json' do
    it 'returns a JSON representation of the resource' do
      member = Tinto::Member.new factory(id: 1)
      JSON.parse(member.to_json).fetch('id').must_equal 1
    end
  end #to_json

  describe '#fetch' do
    it 'retrieves resource data from the DB' do
      member = Tinto::Member.new factory(id: 1, name: 'foo')
      member.sync

      member = Tinto::Member.new factory(id: 1)
      member.fetch
      member.attributes.fetch('name').must_equal 'foo'
    end
  end #fetch

  describe '#sync' do
    it 'persists changes to the member' do
      resource  = factory(id: 1, name: 'foo')
      member    = Tinto::Member.new resource
      member.sync

      attributes = JSON.parse($redis.get resource.storage_key)
      attributes.fetch('name').must_equal 'foo'
    end

    it 'raises InvalidMember unless resource valid' do
      resource  = factory(id: 1, name: 'foo')
      member    = Tinto::Member.new resource
      def resource.valid?; false; end

      lambda { member.sync }.must_raise InvalidMember
    end
  end #sync

  describe '#update' do
  end

  describe '#destroy' do
  end

  describe '#delete' do
    it 'marks the resource as deleted' do
      member = Tinto::Member.new factory(id: 1)
      member.attributes[:deleted_at].must_be_nil
      member.delete
      member.attributes[:deleted_at].must_be_instance_of Time
    end

    it 'raises InvalidMember unless resource valid' do
      resource  = factory(id: 1, name: 'foo')
      member    = Tinto::Member.new resource
      def resource.valid?; false; end

      lambda { member.delete }.must_raise InvalidMember
    end
  end #delete

  describe '#undelete' do
    it 'marks the resource as not deleted' do
      member = Tinto::Member.new factory(id: 1)
      member.delete
      member.attributes[:deleted_at].must_be_instance_of Time
      member.undelete
      member.attributes[:deleted_at].must_be_nil
    end

    it 'raises InvalidMember if resource is not marked as deleted' do
      member = Tinto::Member.new factory(id: 1)
      lambda { member.undelete }.must_raise InvalidMember
    end

    it 'raises InvalidMember unless resource valid' do
      resource  = factory(id: 1, name: 'foo')
      member    = Tinto::Member.new resource

      member.delete
      def resource.valid?; false; end

      lambda { member.undelete }.must_raise InvalidMember
    end
  end #undelete

  describe '#destroy' do
  end #destroy

  def factory(attributes={})
    member = OpenStruct.new(attributes)
    def member.valid?(*args); true; end
    def member.attributes; self.marshal_dump; end
    def member.storage_key; 'test'; end
    def member.attributes=(attributes={}); self.marshal_load attributes; end
    member
  end
end # Tinto::Member
  
