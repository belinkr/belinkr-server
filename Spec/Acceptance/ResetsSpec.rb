# encoding: utf-8
require 'minitest/autorun'
require 'rack/test'
require 'json'
require_relative '../../API/Resets'
require_relative '../Support/Helpers'
require_relative '../Support/DocHelpers'
require_relative '../Factories/Reset'

$redis ||= Redis.new
$redis.select 8

include Belinkr

describe API do
  def app; API.new; end
  include Spec::API::Helpers

  before { $redis.flushdb }

  request 'POST /resets' do
    outcome 'creates a password reset' do
      actor, profile = create_user_and_profile
      post '/resets', { email: actor.email }.to_json

      last_response.status.must_equal 201
      last_response.body.must_be_empty
    end

    outcome 'returns 201 if email not found, to avoid a user enumeration attack' do
      post '/resets', { email: 'nonexistent@belinkr.com' }.to_json
      last_response.status.must_equal 201
      last_response.body.must_be_empty
    end
  end # POST /resets

  request 'GET /resets/:reset_id' do
    outcome 'retrieves a password reset' do
      actor, profile = create_user_and_profile
      xpost '/resets', { email: actor.email }.to_json

      resets  = Reset::Collection.new.fetch
      reset   = resets.first.fetch

      get "/resets/#{reset.id}"

      last_response.status.must_equal 200
      last_response.body.must_be_empty
    end
  end # GET /resets/:reset_id

  request 'PUT /resets/:reset_id' do
    outcome 'sets a new password' do
      actor, profile = create_user_and_profile
      xpost '/resets', { email: actor.email }.to_json

      resets  = Reset::Collection.new.fetch
      reset   = resets.first.fetch

      User::Member.new(id: reset.user_id).fetch.password
        .must_equal actor.password

      put "/resets/#{reset.id}", { password: 'changed' }.to_json

      last_response.status.must_equal 200
      last_response.body.must_be_empty

      changed_actor = User::Member.new(id: reset.user_id).fetch
      changed_actor.password   .wont_equal actor.password
    end
  end # PUT /resets/:reset_id
end # API

