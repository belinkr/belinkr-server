# encoding: utf-8
require 'minitest/autorun'
require 'rack/test'
require 'json'
require_relative '../../API/Followers'
require_relative '../Support/Helpers'
require_relative '../Support/DocHelpers'

$redis ||= Redis.new
$redis.select 8

include Belinkr

describe API do
  include Spec::API::Helpers
  def app; API.new; end

  before do
    $redis.flushdb
  end

  request 'GET /followers' do
    outcome 'gets a page of followers for the current user' do
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

  request 'GET /following' do
    outcome 'gets a page of following users for the current user' do
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

  request 'POST /following/:followed_id' do
    outcome 'makes the current user follow the other user' do
      entity    = Factory.entity.sync
      follower, follower_profile  = create_user_and_profile(entity)
      followed, followed_profile  = create_user_and_profile(entity)

      post "/following/#{followed.id}", {}, session_for(follower_profile)
      last_response.status.must_equal 201

      xget "/following", {}, session_for(follower_profile)
      following = JSON.parse(last_response.body)
      following.first.fetch('id').must_equal followed.id

      xget "/followers", {}, session_for(followed_profile)
      followers = JSON.parse(last_response.body)
      followers.first.fetch('id').must_equal follower.id
    end
  end # POST /following/:followed_id

  request 'DELETE /following/:followed_id' do
    outcome 'makes the current user unfollow the other user' do
      entity    = Factory.entity.sync
      follower, follower_profile  = create_user_and_profile(entity)
      followed, followed_profile  = create_user_and_profile(entity)

      xpost "/following/#{followed.id}", {}, session_for(follower_profile)
      last_response.status.must_equal 201

      delete "/following/#{followed.id}", {}, session_for(follower_profile)
      last_response.status.must_equal 204

      xget "/following", {}, session_for(follower_profile)
      following = JSON.parse(last_response.body)
      following.must_be_empty

      xget "/followers", {}, session_for(followed_profile)
      followers = JSON.parse(last_response.body)
      followers.must_be_empty
    end
  end # DELETE /following/:follower_id

  def follow(follower_profile, followed_profile)
    xpost  "/following/#{followed_profile.user_id}",
          {}, session_for(follower_profile)
  end
end # API

