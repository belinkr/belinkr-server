# encoding: utf-8
require 'minitest/autorun'
require_relative '../../Locales/Loader'
require_relative '../../App/Profile/Collection'

include Belinkr

describe Profile::Member do
  describe '#validations' do
    describe 'entity_id' do
      it 'must be present' do
        profiles = Profile::Collection.new
        profiles.valid?.must_equal false
        profiles.errors[:entity_id].must_include 'entity must not be blank'
      end

      it 'must be a number' do
        profiles = Profile::Collection.new(entity_id: 'a')
        profiles.valid?.must_equal false
        profiles.errors[:entity_id].must_include 'entity must be a number'
      end
    end # entity_id
  end
end
