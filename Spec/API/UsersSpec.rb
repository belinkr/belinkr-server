# encoding: utf-8
require 'minitest/autorun'
require 'rack/test'
require 'json'
require_relative '../Support/Helpers'
require_relative '../../API/Users'

include Belinkr
$redis ||= Redis.new
$redis.select 8

describe API do
  def app; API.new; end
  include Rack::Test::Methods
  include Spec::API::Helpers

  before { $redis.flushdb }

  describe 'GET /users' do
    it 'returns the a page of users sorted from newest' do
      actor = create_user_and_profile
      users = (1..30).map { create_user_and_profile }

      get '/users', {}, session_for(actor)
      dump
      last_response.status.must_equal 200

      json_users = JSON.parse(last_response.body)
      json_users.length .must_equal 20
      users.last.id     .must_equal json_users[0]['id']
    end
  end # GET /users

  describe 'GET /users/:id' do
    it 'returns the user' do
      actor, user = create_user_and_profile, create_user_and_profile

      get "/users/#{actor.id}", {}, session_for(actor)
      last_response.status.must_equal 200

      json_user = JSON.parse(last_response.body)
      json_user['id'] .must_equal actor.id
      #json_user['counters'].keys.must_include 'following'
      #json_user['counters'].keys.must_include 'followers'
      #json_user['counters'].keys.must_include 'statuses'
      #json_user.keys.must_include 'relationship'
    end
  end # GET /users/:id

  describe 'PUT /users/:id' do
    it 'updates the user attributes' do
      actor = create_user_and_profile

      get "/users/#{actor.id}", {}, session_for(actor)
      last_response.status.must_equal 200
      changes = JSON.parse(last_response.body)
      changes["first"]  = "Updated"
      changes["id"]     = "1"

      put "/users/#{actor.id}", changes.to_json, session_for(actor)
      dump
      last_response.status.must_equal 200

      json_user = JSON.parse(last_response.body)
      json_user["id"]         .must_equal actor.id
      json_user["first"]      .must_equal changes["first"]
      json_user["created_at"] .must_equal actor.created_at.iso8601.to_s
    end
  end # PUT /users/:id

  describe 'DELETE /users/:id' do
    it 'marks the user as deleted' do
      actor = create_user_and_profile
      delete "/users/#{actor.id}", {}, session_for(actor)
      last_response.status.must_equal 204

      get "/users/#{actor.id}", {}, session_for(actor)
      last_response.status.must_equal 404
    end
  end # DELETE /users/:id

  describe 'GET /users/:id/summary' do
    it 'returns the user' do
      skip
      actor, profile = create_user_and_profile, create_user_and_profile

      get "/users/#{actor.id}/summary", {}, session_for(actor)
      last_response.status.must_equal 200

      json_user = JSON.parse(last_response.body)
      json_user['id'] .must_equal actor.id
      json_user.keys.must_include 'summary'
      json_user['summary'].keys.must_include 'statuses'
      json_user['summary'].keys.must_include 'followers'
      json_user['summary'].keys.must_include 'following'
      json_user['summary'].keys.must_include 'workspaces'
    end
  end # GET /users/:id/summary

end # API
