# encoding: utf-8
require 'minitest/autorun'
require 'rack/test'
require_relative '../Support/Helpers'
require_relative '../Factories/User'
require_relative '../Factories/Scrapbook'
require_relative '../../API/Scrapbooks'

$redis ||= Redis.new
$redis.select 8

include Belinkr

describe Belinkr::API do
  def app; Belinkr::API.new; end
  include Rack::Test::Methods
  include Spec::API::Helpers

  before { $redis.flushdb }

  describe "POST /scrapbooks" do
    it "creates a new scrapbook" do
      user, profile = create_user_and_profile
      post "/scrapbooks", { name: 'scrapbook 1'}.to_json, session_for(profile)

      last_response.status.must_equal 201
      scrapbook = JSON.parse (last_response.body)
      scrapbook.fetch('id')           .wont_be_nil
      scrapbook.fetch('created_at')   .wont_be_nil
    end
  end # POST /scrapbooks

  describe "GET /scrapooks/:id" do
    it "returns the scrapbook" do
      user, profile = create_user_and_profile
      scrapbook     = create_scrapbook_for(profile)

      get "/scrapbooks/#{scrapbook.fetch('id')}", {}, session_for(profile)
      scrapbook = JSON.parse(last_response.body)

      last_response.status      .must_equal 200
      scrapbook.fetch('id')     .wont_be_nil
      scrapbook.fetch('name')   .wont_be_nil
    end

    it "returns 404 if the resource doesn't exist" do
      user, profile = create_user_and_profile

      get "/scrapbooks/999", {}, session_for(profile)

      last_response.status      .must_equal 404
      last_response.body        .must_be_empty
    end
  end # GET /scrapbooks/:id

  describe "GET /scrapbooks" do
    it "returns a page of scrapbooks" do
      user, profile = create_user_and_profile
      25.times { |i| create_scrapbook_for(profile) }

      get "/scrapbooks", {}, session_for(profile)
      
      last_response.status      .must_equal 200
      scrapbooks = JSON.parse(last_response.body)
      scrapbooks.length         .must_equal 20
    end
  end # GET /scrapbooks

  describe "PUT /scrapbooks/:id" do
    it "replaces the scrapbook if it already exists" do
      user, profile = create_user_and_profile
      scrapbook     = create_scrapbook_for(profile)

      put "/scrapbooks/#{scrapbook.fetch('id')}", { name: 'changed' }.to_json,
        session_for(profile)

      last_response.status.must_equal 200
      scrapbook = JSON.parse(last_response.body)
      scrapbook.fetch('id')   .wont_be_nil
      scrapbook.fetch('name') .must_equal 'changed'
    end

    it "presents an errors hash if resource invalid" do
      user, profile = create_user_and_profile
      scrapbook     = create_scrapbook_for(profile)

      put "/scrapbooks/#{scrapbook.fetch('id')}", { name: '' }.to_json, 
        session_for(profile)

      last_response.status.must_equal 400
      scrapbook = JSON.parse(last_response.body)
      scrapbook.fetch('errors').must_include 'name must not be blank'
      scrapbook.fetch('errors')
        .must_include 'name must be between 1 and 250 characters long'
    end
  end # PUT /scrapbooks/:scrapbook_id
  
  describe "DELETE /scrapbooks/:id" do
    it "delete a scapbook " do
      user, profile = create_user_and_profile
      scrapbook     = create_scrapbook_for(profile)

      delete "/scrapbooks/#{scrapbook.fetch('id')}", {}, session_for(profile)
      
      last_response.body      .must_be_empty
      last_response.status    .must_equal 204
    end
  end # DELETE /scrapbooks/:id

  def create_scrapbook_for(profile)
    post "/scrapbooks", { name: Factory.random_string }.to_json,
      session_for(profile)
    scrapbook = JSON.parse(last_response.body)
  end #create_scrapbook_for
end # Belinkr::API

