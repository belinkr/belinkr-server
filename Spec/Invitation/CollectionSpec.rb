# encoding: utf-8
require 'minitest/autorun'
require_relative '../../Locales/Loader'
require_relative '../../App/Invitation/Collection'

include Belinkr

describe Invitation::Collection do
  describe 'validations' do
    describe 'entity_id' do
      it 'must be present' do
        collection = Invitation::Collection.new
        collection.valid?.must_equal false
        collection.errors[:entity_id].must_include 'entity must not be blank'
      end

      it 'is a integer' do
        collection = Invitation::Collection.new(entity_id: 'ad')
        collection.valid?.must_equal false
        collection.errors[:entity_id].must_include 'entity must be a number'
      end
    end #entity_id
  end # validations
end # Invitation::Collection
