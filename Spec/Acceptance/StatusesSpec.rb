# encoding: utf-8
require 'minitest/autorun'
require 'rack/test'
require 'json'
require_relative '../../API/Statuses'
require_relative '../Support/Helpers'
require_relative '../Support/DocHelpers'
require_relative '../Factories/Entity'

include Belinkr
$redis ||= Redis.new
$redis.select 8

describe API do
  def app; API.new; end
  include Spec::API::Helpers

  before { $redis.flushdb }

  request 'GET /timelines' do
    outcome 'returns the general timeline for the actor' do
      user, profile, entity = create_user_and_profile

      xpost '/statuses', { text: 'test' }.to_json, session_for(profile)
      last_response.status.must_equal 201
      status = JSON.parse(last_response.body)

      get '/timelines', {}, session_for(profile)
      last_response.status.must_equal 200
      statuses = JSON.parse(last_response.body)
      statuses.first.fetch('id').must_equal status.fetch('id')
    end
  end # GET /timelines

  request 'GET /timelines/own' do
    outcome 'returns the own timeline for the actor' do
      user, profile, entity = create_user_and_profile

      xpost '/statuses', { text: 'test' }.to_json, session_for(profile)
      last_response.status.must_equal 201
      status = JSON.parse(last_response.body)

      get '/timelines/own', {}, session_for(profile)

      last_response.status.must_equal 200
      statuses = JSON.parse(last_response.body)
      statuses.first.fetch('id').must_equal status.fetch('id')
    end
  end # GET /timelines/own

  request 'GET /timelines/workspaces' do
    outcome 'returns the workspaces timeline for the actor' do
      user, profile, entity = create_user_and_profile

      get '/timelines/workspaces', {}, session_for(profile)

      last_response.status.must_equal 200
      statuses = JSON.parse(last_response.body)
      statuses.must_be_empty
    end
  end # GET /timelines/workspaces

  request 'GET /timelines/files' do
    outcome 'returns the files timeline for the actor' do
      user, profile, entity = create_user_and_profile

      get '/timelines/files', {}, session_for(profile)

      last_response.status.must_equal 200
      statuses = JSON.parse(last_response.body)
      statuses.must_be_empty
    end
  end # GET /timelines/files

  request 'POST /statuses' do
    outcome 'creates a new status in the user scope' do
      user, profile, entity = create_user_and_profile
      post '/statuses', { text: 'test' }.to_json, session_for(profile)

      last_response.status.must_equal 201
    end
  end # POST /timelines

  request 'DELETE /statuses/:status_id' do
    outcome 'deletes a status in the user scope' do
      user, profile, entity = create_user_and_profile
      xpost '/statuses', { text: 'test' }.to_json, session_for(profile)

      status = JSON.parse(last_response.body)
      delete "/statuses/#{status.fetch('id')}", {}, session_for(profile)

      last_response.status.must_equal 204

      xget "/statuses/#{status.fetch('id')}", {}, session_for(profile)
      last_response.status.must_equal 404
    end
  end # DELETE /timelines/:status_id
end # API

