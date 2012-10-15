# encoding: utf-8
require 'minitest/autorun'
require_relative '../../init'
require_relative '../../app/follower/collection'

include Belinkr

describe Follower::Collection do
  describe 'validations' do
    describe '#user_id' do
      it 'must be present' do
        collection = Follower::Collection.new
        collection.valid?.must_equal false

        collection.errors[:user_id].must_include 'user must not be blank'
      end

      it 'must be a number' do
        collection = Follower::Collection.new
        collection.valid?.must_equal false

        collection.errors[:user_id].must_include 'user must be a number'
      end
    end #user_id

    describe '#entity_id' do
      it 'must be present' do
        collection = Follower::Collection.new
        collection.valid?.must_equal false

        collection.errors[:entity_id].must_include 'entity must not be blank'
      end

      it 'must be a number' do
        collection = Follower::Collection.new
        collection.valid?.must_equal false

        collection.errors[:entity_id].must_include 'entity must be a number'
      end
    end #entity_id
  end # validations
end # Follower::Collection
