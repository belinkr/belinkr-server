# encoding: utf-8
require 'minitest/autorun'
require 'rack/test'
require 'json'
require_relative '../../API/Workspaces'
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

  describe 'POST /workspaces' do
    it 'creates a new workspace' do
      actor, profile, entity = create_user_and_profile
      name    = Factory.random_string

      post '/workspaces', { name: name }.to_json, session_for(profile)
      last_response.status.must_equal 201

      json_workspace = JSON.parse last_response.body
      json_workspace.fetch('name').must_equal name
    end
  end # POST /workspaces

  describe 'GET /workspaces/:workspace_id' do
    it 'it returns a workspace' do
      actor, profile, entity = create_user_and_profile
      workspace = create_workspace_by(profile)
      get "/workspaces/#{workspace.fetch('id')}", {}, session_for(profile)

      last_response.status        .must_equal 200
      json_workspace = JSON.parse(last_response.body)
      json_workspace.fetch('name') .must_equal workspace.fetch('name')
    end

    it 'returns 404 if the resource does not exist' do
      actor, profile, entity = create_user_and_profile

      get "/workspaces/9999", {}, session_for(profile)
      last_response.status  .must_equal 404
      last_response.body    .must_be_empty
    end

    it 'returns the relationship with the current user' do
      skip
    end

    it 'returns the number of statuses in the workspace' do
      actor, profile, entity = create_user_and_profile
      workspace = create_workspace_by(profile)
      get "/workspaces/#{workspace.fetch('id')}", {}, session_for(profile)

      last_response.status        .must_equal 200
      json_workspace = JSON.parse(last_response.body)
      json_workspace.fetch('counters').fetch('users').must_equal 0
    end

    it 'returns the number of participants in the workspace' do
      actor, profile, entity = create_user_and_profile
      workspace = create_workspace_by(profile)
      get "/workspaces/#{workspace.fetch('id')}", {}, session_for(profile)

      last_response.status        .must_equal 200
      json_workspace = JSON.parse(last_response.body)
      json_workspace.fetch('counters').fetch('users').must_equal 0
      json_workspace.fetch('counters').fetch('statuses').must_equal 0
    end

    it 'returns the number of administrators in the workspace' do
      skip
    end

    it 'returns the number of collaborators in the workspace' do
      skip
    end
  end # GET /workspaces/:workspace_id

  describe "GET /workspaces" do
    it "it return all workspaces in the entity" do
      actor, profile, entity = create_user_and_profile
      5.times { create_workspace_by(profile) }

      get '/workspaces', {}, session_for(profile)

      last_response.status.must_equal 200
      workspaces = JSON.parse(last_response.body)
      workspaces.size.must_equal 5
    end

    it "returns a page" do
      actor, profile, entity = create_user_and_profile
      50.times { create_workspace_by(profile) }

      get '/workspaces?page=1', {}, session_for(profile)

      last_response.status.must_equal 200
      workspaces = JSON.parse(last_response.body)
      workspaces.size.must_equal 20
    end
  end # GET /workspaces

  describe "PUT /workspaces/:workspace_id" do
    it "updates the workspace" do
      actor, profile, entity = create_user_and_profile
      workspace = create_workspace_by(profile)
      changes   = { name: "changed" }

      put "/workspaces/#{workspace.fetch('id')}", changes.to_json,
          session_for(profile)

      last_response.status.must_equal 200
      workspace = JSON.parse(last_response.body)
      workspace.fetch('name').must_equal 'changed'
    end

    it "presents an errors hash if resource invalid" do
      actor, profile, entity = create_user_and_profile
      workspace = create_workspace_by(profile)
      changes   = { name: '' }

      put "/workspaces/#{workspace.fetch('id')}", changes.to_json,
          session_for(profile)

      last_response.status.must_equal 400

      workspace = JSON.parse(last_response.body)
      workspace.fetch('errors').wont_be_empty
    end
  end # PUT /workspaces/:workspace_id

  describe "DELETE /workspaces/:workspace_id" do
    it "deletes the workspace" do
      actor, profile, entity = create_user_and_profile
      workspace = create_workspace_by(profile)
      delete "/workspaces/#{workspace.fetch('id')}", {}, session_for(profile)

      last_response.status.must_equal 204
      last_response.body  .must_be_empty
    end
  end # DELETE /workspaces/:workspace_id

  describe "POST /workspaces/:workspace_id/invitations" do
    it "creates an invitation" do
      actor, profile, entity = create_user_and_profile
      workspace = create_workspace_by(profile)

      invited = Factory.user.sync
      post  "/workspaces/#{workspace.fetch('id')}/invitations", 
            { invited_id: invited.id }.to_json, session_for(profile)

      last_response.status.must_equal 201

      invitation = JSON.parse(last_response.body)
      invitation.fetch('state' )     .must_equal 'pending'
    end
  end # POST /workspaces/:workspace_id/invitations

  describe "GET /workspaces/:workspace_id/invitations" do
    it "gets a page of invitations" do
      actor, profile, entity = create_user_and_profile
      workspace = create_workspace_by(profile)
      users = (1..50).map do 
        invited  = Factory.user.sync
        post  "/workspaces/#{workspace.fetch('id')}/invitations", 
              { invited_id: invited.id }.to_json, session_for(profile)
      end

      get "/workspaces/#{workspace.fetch('id')}/invitations?page=1",
          {}, session_for(profile)

      last_response.status.must_equal 200
      invitations = JSON.parse(last_response.body)
      invitations.size.must_equal 20
    end
  end # GET /workspaces/:workspace_id/invitations

  describe "GET /workspaces/:workspace_id/invitations/:invitation_id" do
    it "retrieves an invitation" do
      actor, profile, entity        = create_user_and_profile
      invited_user, invited_profile = create_user_and_profile(entity)

      workspace   = create_workspace_by(profile)
      invitation  = create_invitation_for(workspace, profile, invited_user)

      get "/workspaces/#{workspace.fetch('id')}" +
          "/invitations/#{invitation.fetch('id')}", 
          {}, session_for(profile)

      last_response.status.must_equal 200
      invitation = JSON.parse(last_response.body)
      invitation.fetch('id').must_equal invitation.fetch('id')
    end
  end # GET /workspaces/:workspace_id/invitations/accepted/:invitation_id

  describe "POST /workspaces/:workspace_id/invitations/accepted/:invitation_id" do
    it "accepts an invitation" do
      actor, profile, entity        = create_user_and_profile
      invited_user, invited_profile = create_user_and_profile(entity)

      workspace   = create_workspace_by(profile)
      invitation  = create_invitation_for(workspace, profile, invited_user)

      post  "/workspaces/#{workspace.fetch('id')}" + 
            "/invitations/accepted/#{invitation.fetch('id')}", 
            {}, session_for(invited_profile)

      last_response.status.must_equal 200
      invitation = JSON.parse(last_response.body)
      invitation.fetch('state').must_equal 'accepted'
    end
  end # PUT /workspaces/:workspace_id/invitations/accepted/:invitation_id

  describe "PUT /workspaces/:workspace_id/invitations/rejected/:invitation_id" do
    it "rejects an invitation" do
      actor, profile, entity        = create_user_and_profile
      invited_user, invited_profile = create_user_and_profile(entity)

      workspace   = create_workspace_by(profile)
      invitation  = create_invitation_for(workspace, profile, invited_user)

      post  "/workspaces/#{workspace.fetch('id')}" +
            "/invitations/rejected/#{invitation.fetch('id')}",
            {}, session_for(invited_profile)

      last_response.status.must_equal 200
      invitation = JSON.parse(last_response.body)
      invitation.fetch('state').must_equal 'rejected'
      invitation.fetch('rejected_at').wont_be_empty
    end
  end # PUT /workspaces/:workspace_id/invitations/rejected/:invitation_id

  def create_invitation_for(workspace, profile, invited_user)
    invited ||= Factory.user.sync
    post "/workspaces/#{workspace.fetch('id')}/invitations", 
      { invited_id: invited.id }.to_json, session_for(profile)
    invitation = JSON.parse(last_response.body)
  end

  def create_workspace_by(profile)
    name = Factory.random_string
    post "/workspaces", { name: name }.to_json, session_for(profile)
    JSON.parse(last_response.body)
  end
end # API

