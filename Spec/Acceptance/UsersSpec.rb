# encoding: utf-8
require 'minitest/autorun'
require 'rack/test'
require 'json'
require_relative '../Support/Helpers'
require_relative '../../API/Users'
require_relative '../Support/DocHelpers'

include Belinkr
$redis ||= Redis.new
$redis.select 8

describe API do
  def app; API.new; end
  include Spec::API::Helpers

  before { $redis.flushdb }

  request 'GET /users' do
    outcome 'returns a page of users' do
      actor, profile, entity = create_user_and_profile
      users = (1..30).map { create_user_and_profile(entity) }

      get '/users', {}, session_for(profile)
      last_response.status.must_equal 200

      users = JSON.parse(last_response.body)
      users.length.must_equal 20
    end
  end # GET /users

  request 'GET /users/:user_id' do
    outcome 'returns the user' do
      actor, actor_profile, entity  = create_user_and_profile
      user, profile                 = create_user_and_profile(entity)

      get "/users/#{user.id}", {}, session_for(actor_profile)
      last_response.status.must_equal 200
      user_json = JSON.parse(last_response.body)
      user_json.fetch('id').must_equal user.id
    end
  end # GET /users/:id

  request 'PUT /users/:user_id' do
    outcome 'updates the user attributes' do
      actor, profile, entity = create_user_and_profile

      xget "/users/#{actor.id}", {}, session_for(profile)
      last_response.status.must_equal 200

      changes = { first: 'changed', mobile: 'changed' }

      put "/users/#{actor.id}", changes.to_json, session_for(profile)
      last_response.status.must_equal 200

      user_json = JSON.parse(last_response.body)
      user_json.fetch('id')     .must_equal actor.id
      user_json.fetch('first')  .must_equal 'changed'
      user_json.fetch('mobile') .must_equal 'changed'
    end
  end # PUT /users/:id

  request 'DELETE /users/:user_id' do
    outcome 'marks the user as deleted' do
      actor, profile = create_user_and_profile

      delete "/users/#{actor.id}", {}, session_for(profile)
      last_response.status.must_equal 204

      xget "/users/#{actor.id}", {}, session_for(profile)
      last_response.status.must_equal 404
    end
  end # DELETE /users/:id
end # API

