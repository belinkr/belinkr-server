# encoding: utf-8
require 'minitest/autorun'
require_relative '../../../Locales/Loader'
require_relative '../../../App/Workspace/Autoinvitation/Collection'

include Belinkr

describe Workspace::Autoinvitation::Collection do
  describe 'validations' do
    describe 'workspace_id' do
      it 'must be present' do
        collection = Workspace::Autoinvitation::Collection.new
        collection.valid?.must_equal false
        collection.errors[:workspace_id]
          .must_include 'workspace must not be blank'
      end
    end #workspace_id

    describe 'entity_id' do
      it 'must be present' do
        collection = Workspace::Autoinvitation::Collection.new
        collection.valid?.must_equal false
        collection.errors[:entity_id].must_include 'entity must not be blank'
      end
    end #entity_id
  end # validations
end # Workspace::Autoinvitation::Collection
