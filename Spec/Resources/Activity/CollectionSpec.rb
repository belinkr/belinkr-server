# encoding: utf-8
require 'minitest/autorun'
require_relative '../../../Locales/Loader'
require_relative '../../../Resources/Activity/Collection'

include Belinkr

describe Activity::Collection do
  describe 'validations' do
    describe '#entity_id' do
      it 'must be present' do
        collection = Activity::Collection.new
        collection.valid?.must_equal false

        collection.errors[:entity_id].must_include 'entity must not be blank'
      end
    end #entity_id
  end # validations
end # Activity::Collection

