# encoding: utf-8
require 'minitest/autorun'
require 'rack/test'
require 'json'
require_relative '../support/api_helpers'
require_relative '../factories/account'
require_relative '../../api/followers'

include Belinkr
$redis ||= Redis.new
$redis.select 8

describe API do
  def app; API.new; end
  include Rack::Test::Methods
  include Spec::API::Helpers

  before { $redis.flushdb }

  describe 'GET /followers' do
    it 'gets a page of followers for the current user' do
      followed = Factory.account
      (1..2).map { follow(Factory.account, followed) }
      
      get '/followers', {}, session_for(followed)
      last_response.status.must_equal 200
      json_users = JSON.parse(last_response.body)
      json_users.length       .must_equal 2
      json_users.first["id"].wont_equal followed.id
    end
  end # GET /followers

  describe 'GET /following' do
    it 'gets a page of 20 following users for the current user' do
      follower = Factory.account
      (1..2).map { follow(follower, Factory.account) }
      
      get '/following', {}, session_for(follower)

      last_response.status.must_equal 200
      json_users = JSON.parse(last_response.body)
      json_users.length       .must_equal 2
      json_users.first["id"].wont_equal follower.id
    end
  end # GET /following

  describe 'GET /users/:id/followers' do
    it 'gets a page of followers for the user' do
      user = Factory.account
      (1..2).map { follow(Factory.account, user) }

      get "/users/#{user.id}/followers", {}, session_for(Factory.account)

      last_response.status.must_equal 200
      json_users = JSON.parse(last_response.body)
      json_users.length       .must_equal 2
      json_users.first["id"].wont_equal user.id
    end
  end # GET /users/:id/followers

  describe 'GET /users/:id/following' do
    it 'gets a page of following users for the user' do
      user = Factory.account
      (1..2).map { follow(user, Factory.account) }

      get "/users/#{user.id}/following", {}, session_for(Factory.account)

      last_response.status.must_equal 200
      json_users = JSON.parse(last_response.body)
      json_users.length       .must_equal 2
      json_users.first["id"].wont_equal user.id
    end
  end # GET /users/:id/following

  describe 'POST /users/:id/followers/:follower_id' do
    it 'makes the current user follow the other user' do
      user, follower = Factory.account, Factory.account

      post "/users/#{user.id}/followers", {}, session_for(follower)
      last_response.status.must_equal 201

      get "/users/#{user.id}/followers", {}, session_for(follower)
      json_users = JSON.parse(last_response.body)
      json_users.first['id'].must_equal follower.id
    end
  end # POST /users/:id/followers/:follower_id

  describe 'DELETE /users/:id/followers/:follower_id' do
    it 'makes the current user unfollow the other user' do
      user, follower = Factory.account, Factory.account
      post "/users/#{user.id}/followers", {}, session_for(follower)

      delete "/users/#{user.id}/followers/#{follower.id}", {}, 
        session_for(follower)
      last_response.status.must_equal 204

      get "/users/#{user.id}/followers", {}, session_for(follower)
      json_users = JSON.parse(last_response.body)
      json_users.must_be_empty
    end
  end # DELETE /users/:id/followers/:follower_id

  describe 'GET /counters' do
    it 'gets counters for the user' do
      actor = Factory.account
      get '/counters', {}, session_for(actor)
      last_response.status.must_equal 200

      response = JSON.parse(last_response.body)
      response.keys.must_include 'followers'
      response.keys.must_include 'following'
      response.keys.must_include 'statuses'
    end
  end # GET /counters

  def follow(follower, followed)
    Follower::Orchestrator.new(follower).create(followed)

    [follower, followed]
  end
end # API
