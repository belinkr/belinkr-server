# encoding: utf-8
require 'minitest/autorun'
require 'rack/test'
require 'json'
require_relative '../Support/Helpers'
require_relative '../../API/Autocomplete'
require 'uri'

include Belinkr
$redis ||= Redis.new
$redis.select 8

describe API do
  def app; API.new; end
  include Rack::Test::Methods
  include Spec::API::Helpers

  before { $redis.flushdb }

  describe 'GET /autocomplete/users' do
    it "returns user list matches parameter" do
      user, profile, enity = create_user_and_profile
      query = user.first 
      
      uri = URI.escape "/autocomplete/users?q=#{query}"
      get uri, {}, session_for(profile)
      users = JSON.parse(last_response.body)
      users.first.fetch("name").must_equal user.name
      last_response.status.must_equal 200
    end
  end

  describe "GET /autocomplete/workspaces" do
    it "returns workspace list matches parameter" do
      user, profile, entity = create_user_and_profile
      workspace = workspace_by(profile)
      query = workspace.fetch 'name'
      uri = URI.escape "/autocomplete/workspaces?q=#{query}"
      get uri, {}, session_for(profile)
      workspaces = JSON.parse(last_response.body)
      workspaces.first.fetch("name")
      last_response.status.must_equal 200
    end
  end

  describe "GET /autocomplete/scrapbooks" do
    it "returns scrapbook list matches parameter" do
      user, profile, entity = create_user_and_profile
      scrapbook = scrapbook_by(profile)
      query = scrapbook.fetch 'name'
      uri = URI.escape "/autocomplete/scrapbooks?q=#{query}"
      get uri, {}, session_for(profile)
      scrapbooks = JSON.parse(last_response.body)
      scrapbooks.first.fetch("name")
      last_response.status.must_equal 200
    end
  end

  def workspace_by(profile)
    name = Factory.random_string
    post "/workspaces", { name: name }.to_json, session_for(profile)
    JSON.parse(last_response.body)
  end

  def scrapbook_by(profile)
    name = Factory.random_string
    post "/scrapbooks", { name: name }.to_json, session_for(profile)
    JSON.parse(last_response.body)
  end


end
