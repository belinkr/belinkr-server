# encoding: utf-8
require 'minitest/autorun'
require 'rack/test'
require 'json'
require_relative '../../API/Resets'
require_relative '../Support/Helpers'
require_relative '../Factories/Reset'
require_relative '../../App/Reset/Collection'

include Belinkr
$redis ||= Redis.new
$redis.select 8

describe API do
  def app; API.new; end
  include Rack::Test::Methods
  include Spec::API::Helpers

  before { $redis.flushdb }

  describe 'POST /resets' do
    it 'creates a password reset' do
      profile = create_user_and_profile
      post '/resets', { email: profile.user.fetch.email }

      last_response.status.must_equal 201
      last_response.body.must_be_empty
    end

    it 'returns 201 if email not found, to avoid a user enumeration attack' do
      post '/resets', { email: 'nonexistent@belinkr.com' }
      last_response.status.must_equal 201
      last_response.body.must_be_empty
    end
  end # POST /resets

  describe 'GET /resets/:id' do
    it 'retrieves a password reset' do
      profile = create_user_and_profile
      post '/resets', { email: profile.user.fetch.email }.to_json
      resets  = Reset::Collection.new.fetch
      reset   = resets.first

      get "/resets/#{reset.id}"

      last_response.status.must_equal 200
      last_response.body.must_be_empty
    end
  end # GET /resets/:id

  describe 'PUT /resets/:id' do
    it 'sets a new password' do
      profile = create_user_and_profile
      post '/resets', { email: profile.user.fetch.email }.to_json
      resets  = Reset::Collection.new.fetch
      reset   = resets.first

      put "/resets/#{reset.id}", { password: 'changed' }.to_json
      last_response.status.must_equal 200
      last_response.body.must_be_empty

      User::Member.new(id: reset.user_id).password
        .wont_equal profile.user.password
    end
  end # PUT /resets/:id
end # API
