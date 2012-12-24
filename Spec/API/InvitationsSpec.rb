# encoding: utf-8
require 'minitest/autorun'
require 'rack/test'
require 'json'
require_relative '../../API/Invitations'
require_relative '../Support/Helpers'
require_relative '../Factories/Invitation'
require_relative '../Factories/Entity'

include Belinkr
$redis ||= Redis.new
$redis.select 8

describe API do
  def app; API.new; end
  include Rack::Test::Methods
  include Spec::API::Helpers

  before { $redis.flushdb }

  describe 'POST /invitations' do
    it 'creates an invitation' do
      actor, profile  = create_user_and_profile
      invitation = { invited_name: 'foo', invited_email: 'foo@foo.com' }

      post '/invitations', invitation.to_json, session_for(profile)

      last_response.status.must_equal 201
      invitation = JSON.parse(last_response.body)
      invitation.fetch('id').wont_be_nil
    end
  end # POST /invitations

  describe 'GET /invitations/:invitation_id' do
    it 'retrieves an invitations' do
      actor, profile  = create_user_and_profile
      invitation = { invited_name: 'foo', invited_email: 'foo@foo.com' }

      post '/invitations', invitation.to_json, session_for(profile)

      invitation = JSON.parse(last_response.body)
      get "/invitations/#{invitation.fetch('id')}"

      last_response.status.must_equal 200
    end
  end # GET /invitations/:invitation_id

  describe 'PUT /invitations/:invitation_id' do
    it 'marks an invitation as accepted' do
      actor, profile  = create_user_and_profile
      invitation = { invited_name: 'foo', invited_email: 'foo@foo.com' }

      post '/invitations', invitation.to_json, session_for(profile)

      invitation = JSON.parse(last_response.body)

      user  = {
                first:    "User",
                last:     "111",
                email:    "foo@foo.com",
                password: "changeme"
              }

      put "/invitations/#{invitation.fetch('id')}", user.to_json

      last_response.status.must_equal 200
      user = JSON.parse(last_response.body)

      user.fetch('id')    .wont_be_nil
      user.fetch('name')  .must_equal 'User 111'
    end
  end # PUT /invitations/:invitation_id
end # API

