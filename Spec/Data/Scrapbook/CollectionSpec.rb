# encoding: utf-8
require 'minitest/autorun'
require_relative '../../../Locales/Loader'
require_relative '../../../Data/Scrapbook/Collection'

include Belinkr

describe Scrapbook::Collection do
  describe 'validations' do
    describe 'user_id' do
      it 'must be present' do
        scrapbook = Scrapbook::Collection.new
        scrapbook.valid?.must_equal false
        scrapbook.errors[:user_id].must_include 'user must not be blank'
      end
    end

    describe 'kind' do
      it 'must be present' do
        collection = Scrapbook::Collection.new
        collection.valid?.must_equal false
        collection.errors[:kind].must_include 'kind must not be blank'
      end

      it 'must be own or other' do
        kinds = Scrapbook::Collection::KINDS.join(', ')
        collection = Scrapbook::Collection.new
        collection.valid?.must_equal false
        collection.errors[:kind]
          .must_include "kind must be one of #{kinds}"
      end
    end #kind
  end # validations
end # Scrapbook::Collection

