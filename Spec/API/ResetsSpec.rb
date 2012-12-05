# encoding: utf-8
require 'minitest/autorun'
require 'rack/test'
require 'json'
require_relative '../../API/Resets'
require_relative '../Support/Helpers'
require_relative '../Factories/Reset'

$redis ||= Redis.new
$redis.select 8

include Belinkr

describe API do
  def app; API.new; end
  include Rack::Test::Methods
  include Spec::API::Helpers

  before { $redis.flushdb }

  describe 'POST /resets' do
    it 'creates a password reset' do
      actor, profile = create_user_and_profile
      post '/resets', { email: actor.email }.to_json

      last_response.status.must_equal 201
      last_response.body.must_be_empty
    end

    it 'returns 201 if email not found, to avoid a user enumeration attack' do
      post '/resets', { email: 'nonexistent@belinkr.com' }.to_json
      last_response.status.must_equal 201
      last_response.body.must_be_empty
    end
  end # POST /resets

  describe 'GET /resets/:reset_id' do
    it 'retrieves a password reset' do
      actor, profile = create_user_and_profile
      post '/resets', { email: actor.email }.to_json

      resets  = Reset::Collection.new.fetch
      reset   = resets.first.fetch

      get "/resets/#{reset.id}"

      last_response.status.must_equal 200
      last_response.body.must_be_empty
    end
  end # GET /resets/:reset_id

  describe 'PUT /resets/:reset_id' do
    it 'sets a new password' do
      actor, profile = create_user_and_profile
      post '/resets', { email: actor.email }.to_json

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

