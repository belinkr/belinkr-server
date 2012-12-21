require 'minitest/autorun'
require 'tire'
require_relative '../../Support/Helpers'
require_relative '../../../Services/Searcher/TireWrapper'
include Belinkr

describe TireWrapper do
  before  do
    @backend = Object.new.extend TireWrapper
    @backend.index_delete 'test_users'
    @backend.index_create 'test_users'
  end

  describe "#index_create" do
    it "set mapping if given a mapping_hash" do
      @backend.index_delete 'test_users2'
      hash = {
        user: {
          properties: {
            id: {
              type: 'string',
              index: 'not_analyzed'
            },
            name: {
              type: 'string'
            }
          }
        }

      }

      @backend.index_create 'test_users2', hash
      index = Tire.index 'test_users2'
      index.mapping['user']["properties"]["id"]["index"]
        .must_equal "not_analyzed"
    end
  end

  describe "#index_store #index_search" do
    it "store new obj into name" do
      @backend.index_store "test_users", {id: 1, name: 'User 1'}
      @backend.index_store "test_users", {id: 2, name: 'User 2'}
      results= @backend.index_search("test_users", "User")
      results.wont_be_empty
      results[0].fetch("_source").fetch("name").must_equal "User 1"
      results[1].fetch("_source").fetch("name").must_equal "User 2"
    end
  end

  after do
    @backend.index_delete 'test_users'
  end
  
end
