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
      profile, invitation = generate_invitation
      post '/invitations', invitation.to_json, session_for(profile)
      last_response.status.must_equal 201
      json_invitation = JSON.parse(last_response.body)
      json_invitation['id'].wont_be_nil
    end
  end # POST /invitations

  describe 'GET /invitations' do
    it 'retrieves a page of invitations' do
      profile, invitation = generate_invitation
      post '/invitations', invitation.to_json, session_for(profile)
      last_response.status.must_equal 201

      get '/invitations', {}, session_for(profile)
      last_response.status.must_equal 200
      json_invitations = JSON.parse(last_response.body)
      json_invitations.length.must_equal 1
    end
  end # GET /invitations

  describe 'GET /invitations/:id' do
    it 'retrieves an invitations' do
      profile, invitation = generate_invitation
      post '/invitations', invitation.to_json, session_for(profile)
      last_response.status.must_equal 201
      json_invitation = JSON.parse(last_response.body)
      get "/invitations/#{json_invitation['id']}"

      last_response.status.must_equal 200
      #json_invitation = JSON.parse(last_response.body)
      #json_invitation['id'].wont_be_nil
    end
  end # GET /invitations/:id

  describe 'PUT /invitations/:id' do
    it 'marks an invitation as accepted' do
      profile, invitation = generate_invitation
      post '/invitations', invitation.to_json, session_for(profile)
      json_invitation = JSON.parse(last_response.body)

      user  = {
                first:    "User",
                last:     "111",
                email:    "foo@foo.com",
                password: "changeme"
              }

      put "/invitations/#{json_invitation['id']}", user.to_json
      last_response.status.must_equal 200
      json_invitation = JSON.parse(last_response.body)
      json_invitation["state"].must_equal "accepted"
    end
  end # PUT /invitations/:id

  describe 'DELETE /invitations/:id' do
    it 'marks an invitation as deleted' do
      profile, invitation = generate_invitation
      post '/invitations', invitation.to_json, session_for(profile)

      json_invitation = JSON.parse(last_response.body)
      delete "/invitations/#{json_invitation['id']}", {}, session_for(profile)
      last_response.status.must_equal 204
    end
  end # DELETE /invitations/:id

  def generate_invitation
    inviter_profile = create_user_and_profile
    invitation  = Factory.invitation(
                    inviter_id: inviter_profile.user_id, 
                    entity_id:  inviter_profile.entity_id
                  )
    invitation.id = nil
    [inviter_profile, invitation]
  end
end # API
