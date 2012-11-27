# encoding: utf-8
require 'minitest/autorun'
require_relative '../../../../Locales/Loader'
require_relative '../../../../Resources/Workspace/User/Collection'

include Belinkr

describe Workspace::User::Collection do
  describe 'validations' do
    describe '#workspace_id' do
      it 'must be present' do
        collection = Workspace::User::Collection.new
        collection.valid?.must_equal false
        collection.errors[:workspace_id]
          .must_include 'workspace must not be blank'
      end
    end #workspace_id

    describe 'entity_id' do
      it 'must be present' do
        collection = Workspace::User::Collection.new
        collection.valid?.must_equal false
        collection.errors[:entity_id].must_include 'entity must not be blank'
      end
    end #entity_id

    describe 'kind' do
      it 'must be present' do
        collection = Workspace::User::Collection.new
        collection.valid?.must_equal false
        collection.errors[:kind].must_include 'kind must not be blank'
      end

      it 'must be one of KINDS' do
        collection = Workspace::User::Collection.new
        collection.valid?.must_equal false
        kinds = Workspace::User::Collection::KINDS.join(', ')
        collection.errors[:kind].must_include "kind must be one of #{kinds}"
      end
    end #kind
  end # validations
end # Workspace::User::Collection
