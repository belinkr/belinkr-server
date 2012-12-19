# encoding: utf-8
require 'minitest/autorun'
require 'rack/test'
require 'json'
require_relative '../../API/Statuses'
require_relative '../Support/Helpers'
require_relative '../Factories/Entity'

include Belinkr
$redis ||= Redis.new
$redis.select 8

describe API do
  def app; API.new; end
  include Rack::Test::Methods
  include Spec::API::Helpers

  before { $redis.flushdb }

  describe 'GET /timelines' do
    it 'returns the general timeline for the actor' do
      user, profile, entity = create_user_and_profile

      post '/statuses', { text: 'test' }.to_json, session_for(profile)
      last_response.status.must_equal 201
      status = JSON.parse(last_response.body)

      get '/timelines', {}, session_for(profile)
      last_response.status.must_equal 200
      statuses = JSON.parse(last_response.body)
      statuses.first.fetch('id').must_equal status.fetch('id')
    end
  end # GET /timelines

  describe 'GET /timelines/own' do
    it 'returns the own timeline for the actor' do
      user, profile, entity = create_user_and_profile

      post '/statuses', { text: 'test' }.to_json, session_for(profile)
      last_response.status.must_equal 201
      status = JSON.parse(last_response.body)

      get '/timelines/own', {}, session_for(profile)

      last_response.status.must_equal 200
      statuses = JSON.parse(last_response.body)
      statuses.first.fetch('id').must_equal status.fetch('id')
    end
  end # GET /timelines/own

  describe 'GET /timelines/workspaces' do
    it 'returns the workspaces timeline for the actor' do
      user, profile, entity = create_user_and_profile

      get '/timelines/workspaces', {}, session_for(profile)

      last_response.status.must_equal 200
      statuses = JSON.parse(last_response.body)
      statuses.must_be_empty
    end
  end # GET /timelines/workspaces

  describe 'GET /timelines/files' do
    it 'returns the files timeline for the actor' do
      user, profile, entity = create_user_and_profile

      get '/timelines/files', {}, session_for(profile)

      last_response.status.must_equal 200
      statuses = JSON.parse(last_response.body)
      statuses.must_be_empty
    end
  end # GET /timelines/files

  describe 'POST /timelines' do
    it 'creates a new status in the user scope' do
      user, profile, entity = create_user_and_profile
      post '/statuses', { text: 'test' }.to_json, session_for(profile)

      last_response.status.must_equal 201
    end
  end # POST /timelines

  describe 'DELETE /timelines/:status_id' do
    it 'deletes a status in the user scope' do
      user, profile, entity = create_user_and_profile
      post '/statuses', { text: 'test' }.to_json, session_for(profile)

      status = JSON.parse(last_response.body)
      delete "/statuses/#{status.fetch('id')}", {}, session_for(profile)

      last_response.status.must_equal 204

      get "/statuses/#{status.fetch('id')}", {}, session_for(profile)
      last_response.status.must_equal 404
    end
  end # DELETE /timelines/:status_id
end # API

