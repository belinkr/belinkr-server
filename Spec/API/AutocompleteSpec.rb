# encoding: utf-8
require 'minitest/autorun'
require 'rack/test'
require 'json'
require_relative '../Support/Helpers'
require_relative '../../API/Autocomplete'
require_relative '../../Services/Searcher/TireWrapper'
require 'uri'

include Belinkr
$redis ||= Redis.new
$redis.select 8
module Belinkr
  class API
    use PryRescue::Rack
  end
end


describe API do
  def app; API.new; end
  include Rack::Test::Methods
  include Spec::API::Helpers

  before do
    $redis.flushdb 
    @tire_obj = Object.new.extend TireWrapper
  end

  describe 'GET /autocomplete/users' do
    before do
      @tire_obj.index_delete 'users'
    end

    it "returns user list matches parameter" do
      user, profile, entity = create_user_and_profile
      query = user.first[0..1]
      @tire_obj.index_store_with_type 'users', user.attributes
      
      uri = URI.escape "/autocomplete/users?q=#{query}"
      get uri, {}, session_for(profile)
      users = JSON.parse(last_response.body)
      users.first.fetch("name").must_equal user.name
      last_response.status.must_equal 200
    end

    it "returns user in all entities" do
      user, profile, entity = create_user_and_profile
      user2, profile2, entity2 = create_user_and_profile
      @tire_obj.index_store_with_type 'users', user.attributes
      @tire_obj.index_store_with_type 'users', user2.attributes
      uri = URI.escape "/autocomplete/users?q=*"
      get uri, {}, session_for(profile)
      users = JSON.parse(last_response.body)

      users.size.must_equal 2
      user_names = users.map do |user|
        user.fetch("name")
      end
      user_names.must_include user.name
      user_names.must_include user2.name

      get uri, {}, session_for(profile2)
      users = JSON.parse(last_response.body)
      users.size.must_equal 2
    end
  end

  describe "GET /autocomplete/workspaces" do
    before do
      @tire_obj.index_delete 'workspaces'
      @tire_obj.index_refresh 'workspaces'
      @user, @profile, @entity = create_user_and_profile
      @user2, @profile2, @entity2 = create_user_and_profile
      @workspace = workspace_by(@profile)
      @workspace2 = workspace_by(@profile2)
      #neeed to sync to redis db because in presenter, it will call fetch and
      #read it from redis db
      @workspace.sync
      @workspace2.sync

    end

    it "returns workspace list matches parameter" do
      hash= @workspace.attributes
      # elastic default date parser not accept ruby's date format, it has
      # error:
      # MapperParsingException[failed to parse date field [2012-12-18 11:32:26
      # +0800], tried both date format [dateOptionalTime], and timestamp
      # number]; nested: IllegalArgumentException
      [:updated_at, :created_at, :deleted_at].each do |timestamp|
        hash[timestamp] = hash[timestamp].iso8601 if hash[timestamp]
      end
      @tire_obj.index_store_with_type 'workspaces', hash
      query = @workspace.name
      uri = URI.escape "/autocomplete/workspaces?q=#{query}"
      get uri, {}, session_for(@profile)
      workspaces = JSON.parse(last_response.body)
      workspaces.first.fetch("name")
      last_response.status.must_equal 200
    end
    
    it "only search the workspaces in the same entity" do
      hash= @workspace.attributes
      [:updated_at, :created_at, :deleted_at].each do |timestamp|
        hash[timestamp] = hash[timestamp].iso8601 if hash[timestamp]
      end
      @tire_obj.index_store_with_type 'workspaces', hash

      hash= @workspace2.attributes
      [:updated_at, :created_at, :deleted_at].each do |timestamp|
        hash[timestamp] = hash[timestamp].iso8601 if hash[timestamp]
      end
      @tire_obj.index_store_with_type 'workspaces', hash
 
      query = @workspace.name
      uri = URI.escape "/autocomplete/workspaces?q=*"
      get uri, {}, session_for(@profile)
      workspaces = JSON.parse(last_response.body)
      workspaces.size.must_equal 1
      workspaces.first.fetch("name")
      last_response.status.must_equal 200
      
    end
  end

  describe "GET /autocomplete/scrapbooks" do
    before do
      @tire_obj.index_delete 'scrapbooks'
      @tire_obj.index_refresh 'scrapbooks'
    end
    it "returns scrapbook list matches parameter" do
      user, profile, entity = create_user_and_profile
      scrapbook = scrapbook_by(profile)
      scrapbook.sync
      hash = scrapbook.attributes

      [:updated_at, :created_at, :deleted_at].each do |timestamp|
        hash[timestamp] = hash[timestamp].iso8601 if hash[timestamp]
      end
      @tire_obj.index_store_with_type 'scrapbooks', hash
      query = scrapbook.name
      uri = URI.escape "/autocomplete/scrapbooks?q=#{query}"
      # if call fetch in Tinto::Precenter::Collection#as_poro, it would fail
      get uri, {}, session_for(profile)
      scrapbooks = JSON.parse(last_response.body)

      scrapbooks.first.fetch("name").must_equal scrapbook.name
      last_response.status.must_equal 200
    end
    it "only return scrapbook belong to this user" do
      user, profile, entity = create_user_and_profile
      user2, profile2, entity2 = create_user_and_profile
      scrapbook = scrapbook_by(profile)
      scrapbook2 = scrapbook_by(profile2)
      scrapbook.sync
      scrapbook2.sync
      hash = scrapbook.attributes
      [:updated_at, :created_at, :deleted_at].each do |timestamp|
        hash[timestamp] = hash[timestamp].iso8601 if hash[timestamp]
      end
      @tire_obj.index_store_with_type 'scrapbooks', hash
 
      hash = scrapbook2.attributes
      [:updated_at, :created_at, :deleted_at].each do |timestamp|
        hash[timestamp] = hash[timestamp].iso8601 if hash[timestamp]
      end
      @tire_obj.index_store_with_type 'scrapbooks', hash

      uri = URI.escape "/autocomplete/scrapbooks?q=*"
      # if call fetch in Tinto::Precenter::Collection#as_poro, it would fail
      get uri, {}, session_for(profile)
      scrapbooks = JSON.parse(last_response.body)
      scrapbooks.size.must_equal 1

    end
  end

  def workspace_by(profile)
    name = Factory.random_string
    workspace = Factory.workspace name: name, user_id: profile.user_id, entity_id: profile.entity_id
    #post "/workspaces", { name: name }.to_json, session_for(profile)
    #JSON.parse(last_response.body)
  end

  def scrapbook_by(profile)
    name = Factory.random_string
    scrapbook = Factory.scrapbook name: name, user_id: profile.user_id
    #post "/scrapbooks", { name: name }.to_json, session_for(profile)
    #JSON.parse(last_response.body)
  end



end
