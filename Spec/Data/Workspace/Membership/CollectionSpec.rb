# encoding: utf-8
require 'minitest/autorun'
require_relative '../../../../Locales/Loader'
require_relative '../../../../Data/Workspace/Membership/Collection'

include Belinkr

describe Workspace::Membership::Collection do
  describe 'validations' do
    describe 'user_id' do
      it 'must be present' do
        collection = Workspace::Membership::Collection.new
        collection.valid?.must_equal false
        collection.errors[:user_id].must_include 'user must not be blank'
      end
    end #user_id

    describe 'entity_id' do
      it 'must be present' do
        collection = Workspace::Membership::Collection.new
        collection.valid?.must_equal false
        collection.errors[:entity_id].must_include 'entity must not be blank'
      end
    end #entity_id

    describe 'kind' do
      it 'must be present' do
        collection = Workspace::Membership::Collection.new
        collection.valid?.must_equal false
        collection.errors[:kind].must_include 'kind must not be blank'
      end

      it 'must be one of KINDS' do
        collection = Workspace::Membership::Collection.new
        collection.valid?.must_equal false
        kinds = Workspace::Membership::Collection::KINDS.join(', ')
        collection.errors[:kind].must_include "kind must be one of #{kinds}"
      end
    end #kind
  end # validations
end # Workspace::Membership::Collection

