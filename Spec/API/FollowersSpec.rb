# encoding: utf-8
require 'minitest/autorun'
require 'rack/test'
require 'json'
require_relative '../../API/Followers'
require_relative '../Support/Helpers'

$redis ||= Redis.new
$redis.select 8

include Belinkr

describe API do
  def app; API.new; end
  include Rack::Test::Methods
  include Spec::API::Helpers

  before do
    $redis.flushdb
  end

  describe 'GET /followers' do
    it 'gets a page of followers for the current user' do
      entity    = Factory.entity.sync
      follower, follower_profile  = create_user_and_profile(entity)
      followed, followed_profile  = create_user_and_profile(entity)

      follow(follower_profile, followed_profile)

      get '/followers', {}, session_for(followed_profile)

      last_response.status.must_equal 200
      followers = JSON.parse(last_response.body)

      followers.length            .must_equal 1
      followers.first.fetch('id') .wont_equal followed.id
    end
  end # GET /followers

  describe 'GET /following' do
    it 'gets a page of following users for the current user' do
      entity    = Factory.entity.sync
      follower, follower_profile  = create_user_and_profile(entity)
      followed, followed_profile  = create_user_and_profile(entity)

      follow(follower_profile, followed_profile)

      get '/following', {}, session_for(follower_profile)

      last_response.status.must_equal 200
      following = JSON.parse(last_response.body)

      following.length            .must_equal 1
      following.first.fetch('id') .wont_equal follower.id
    end
  end # GET /following

  describe 'POST /following/:followed_id' do
    it 'makes the current user follow the other user' do
      entity    = Factory.entity.sync
      follower, follower_profile  = create_user_and_profile(entity)
      followed, followed_profile  = create_user_and_profile(entity)

      post "/following/#{followed.id}", {}, session_for(follower_profile)
      last_response.status.must_equal 201

      get "/following", {}, session_for(follower_profile)
      following = JSON.parse(last_response.body)
      following.first.fetch('id').must_equal followed.id

      get "/followers", {}, session_for(followed_profile)
      followers = JSON.parse(last_response.body)
      followers.first.fetch('id').must_equal follower.id
    end
  end # POST /following/:followed_id

  describe 'DELETE /following/:followed_id' do
    it 'makes the current user unfollow the other user' do
      entity    = Factory.entity.sync
      follower, follower_profile  = create_user_and_profile(entity)
      followed, followed_profile  = create_user_and_profile(entity)

      post "/following/#{followed.id}", {}, session_for(follower_profile)
      last_response.status.must_equal 201

      delete "/following/#{followed.id}", {}, session_for(follower_profile)
      last_response.status.must_equal 204

      get "/following", {}, session_for(follower_profile)
      following = JSON.parse(last_response.body)
      following.must_be_empty

      get "/followers", {}, session_for(followed_profile)
      followers = JSON.parse(last_response.body)
      followers.must_be_empty
    end
  end # DELETE /following/:follower_id

  def follow(follower_profile, followed_profile)
    post  "/following/#{followed_profile.user_id}",
          {}, session_for(follower_profile)
  end
end # API

