# encoding: utf-8
require 'minitest/autorun'
require_relative '../../../Locales/Loader'
require_relative '../../../Resources/Follower/Collection'

include Belinkr

describe Follower::Collection do
  describe 'validations' do
    describe '#profile_id' do
      it 'must be present' do
        collection = Follower::Collection.new
        collection.valid?.must_equal false

        collection.errors[:profile_id].must_include 'profile must not be blank'
      end
    end #profile_id

    describe '#entity_id' do
      it 'must be present' do
        collection = Follower::Collection.new
        collection.valid?.must_equal false

        collection.errors[:entity_id].must_include 'entity must not be blank'
      end
    end #entity_id
  end # validations
end # Follower::Collection
