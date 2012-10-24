# encoding: utf-8
require 'minitest/autorun'
require 'rack/test'
require 'json'
require_relative '../Support/Helpers'
require_relative '../../API/Followers'
require_relative '../../App/Status/Collection'

include Belinkr
$redis ||= Redis.new
$redis.select 8

describe API do
  def app; API.new; end
  include Rack::Test::Methods
  include Spec::API::Helpers

  before do
    $redis.flushdb
  end

  describe 'GET /followers' do
    it 'gets a page of followers for the current user' do
      entity    = Factory.entity
      follower  = create_user_and_profile(entity.id)
      followed  = create_user_and_profile(entity.id)

      follow(follower, followed)

      get '/followers', {}, session_for(followed)
      last_response.status.must_equal 200
      json_users = JSON.parse(last_response.body)
      json_users.length       .must_equal 1
      json_users.first["id"].wont_equal followed.id
    end
  end # GET /followers

  describe 'GET /following' do
    it 'gets a page off following users for the current user' do
      entity    = Factory.entity
      follower  = create_user_and_profile(entity.id)
      followed  = create_user_and_profile(entity.id)
      follow(follower, followed)

      get '/following', {}, session_for(follower)
      last_response.status.must_equal 200
      json_users = JSON.parse(last_response.body)
      json_users.length       .must_equal 1
      json_users.first["id"].wont_equal follower.id
    end
  end # GET /following

  describe 'GET /users/:id/followers' do
    it 'gets a page of followers for the user' do
      entity    = Factory.entity
      follower  = create_user_and_profile(entity.id)
      followed  = create_user_and_profile(entity.id)
      follow(follower, followed)

      get "/users/#{followed.id}/followers", {}, session_for(followed)
      last_response.status.must_equal 200
      json_users = JSON.parse(last_response.body)
      json_users.length       .must_equal 1
      json_users.first["id"].wont_equal followed.id
    end
  end # GET /users/:id/followers

  describe 'GET /users/:id/following' do
    it 'gets a page of following users for the user' do
      entity    = Factory.entity
      follower  = create_user_and_profile(entity.id)
      followed  = create_user_and_profile(entity.id)
      follow(follower, followed)

      get "/users/#{follower.id}/following", {}, session_for(followed)

      last_response.status.must_equal 200
      json_users = JSON.parse(last_response.body)
      json_users.length       .must_equal 1
      json_users.first["id"].wont_equal follower.id
    end
  end # GET /users/:id/following

  describe 'POST /users/:id/followers/:follower_id' do
    it 'makes the current user follow the other user' do
      entity    = Factory.entity
      follower  = create_user_and_profile(entity.id)
      followed  = create_user_and_profile(entity.id)

      post "/users/#{followed.id}/followers", {}, session_for(follower)
      last_response.status.must_equal 201

      get "/users/#{followed.id}/followers", {}, session_for(follower)
      json_users = JSON.parse(last_response.body)
      json_users.first['id'].must_equal follower.id
    end
  end # POST /users/:id/followers/:follower_id

  describe 'DELETE /users/:id/followers/:follower_id' do
    it 'makes the current user unfollow the other user' do
      entity    = Factory.entity
      follower  = create_user_and_profile(entity.id)
      followed  = create_user_and_profile(entity.id)

      post "/users/#{followed.id}/followers", {}, session_for(follower)
      last_response.status.must_equal 201

      delete "/users/#{followed.id}/followers/#{follower.id}", {}, 
        session_for(follower)
      last_response.status.must_equal 204

      get "/users/#{followed.id}/followers", {}, session_for(follower)
      json_users = JSON.parse(last_response.body)
      json_users.must_be_empty
    end
  end # DELETE /users/:id/followers/:follower_id

  describe 'GET /counters' do
    it 'gets counters for the user' do
      skip
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
    @actor           = follower
    @followed        = followed
    @followers       = Follower::Collection.new(profile_id: @followed.id, 
                        entity_id: @followed.entity_id)
    @following       = Following::Collection.new(profile_id: @actor.id,
                        entity_id: @followed.entity_id)
    @actor_timeline  = Status::Collection.new(kind: 'general', context: @actor)
    @latest_statuses = Status::Collection.new(kind: 'own', context: @followed)

    @options = {
      entity:           @entity,
      actor:            @actor,
      followed:         @followed,
      followers:        @followers,
      following:        @following,
      actor_timeline:   @actor_timeline,
      latest_statuses:  @latest_statuses
    }
    context = FollowUserInEntity.new(@options)
    context.call
    context.sync
  end
end # API

