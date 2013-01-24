# encoding: utf-8
require 'minitest/autorun'
require 'rack/test'
require 'json'
require_relative '../../API/Workspaces'
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

  request 'POST /workspaces' do
    outcome 'creates a new workspace' do
      actor, profile, entity = create_user_and_profile
      name    = Factory.random_string

      post '/workspaces', { name: name }.to_json, session_for(profile)
      last_response.status.must_equal 201

      json_workspace = JSON.parse last_response.body
      json_workspace.fetch('name').must_equal name
    end
  end # POST /workspaces

  request 'GET /workspaces/:workspace_id' do
    outcome 'it returns a workspace' do
      actor, profile, entity = create_user_and_profile
      workspace = workspace_by(profile)
      get "/workspaces/#{workspace.fetch('id')}", {}, session_for(profile)

      last_response.status        .must_equal 200
      json_workspace = JSON.parse(last_response.body)
      json_workspace.fetch('name') .must_equal workspace.fetch('name')
    end

    outcome 'returns 404 if the resource does not exist' do
      actor, profile, entity = create_user_and_profile

      get "/workspaces/9999", {}, session_for(profile)
      last_response.status  .must_equal 404
      last_response.body    .must_be_empty
    end

    outcome 'returns the relationship with the current user' do
      skip
    end

    outcome 'returns the number of statuses in the workspace' do
      actor, profile, entity = create_user_and_profile
      workspace = workspace_by(profile)
      get "/workspaces/#{workspace.fetch('id')}", {}, session_for(profile)

      last_response.status        .must_equal 200
      json_workspace = JSON.parse(last_response.body)
      json_workspace.fetch('counters').fetch('users').must_equal 0
    end

    outcome 'returns the number of participants in the workspace' do
      actor, profile, entity = create_user_and_profile
      workspace = workspace_by(profile)
      get "/workspaces/#{workspace.fetch('id')}", {}, session_for(profile)

      last_response.status        .must_equal 200
      json_workspace = JSON.parse(last_response.body)
      json_workspace.fetch('counters').fetch('statuses').must_equal 0
    end

    outcome 'returns the number of administrators in the workspace' do
      actor, profile, entity = create_user_and_profile
      workspace = workspace_by(profile)
      get "/workspaces/#{workspace.fetch('id')}", {}, session_for(profile)

      last_response.status        .must_equal 200
      json_workspace = JSON.parse(last_response.body)
      json_workspace.fetch('counters').fetch('administrators').must_equal 1
    end

    outcome 'returns the number of collaborators in the workspace' do
      actor, profile, entity = create_user_and_profile
      workspace = workspace_by(profile)
      get "/workspaces/#{workspace.fetch('id')}", {}, session_for(profile)

      last_response.status        .must_equal 200
      json_workspace = JSON.parse(last_response.body)
      json_workspace.fetch('counters').fetch('collaborators').must_equal 0
    end
  end # GET /workspaces/:workspace_id

  request "GET /workspaces" do
    outcome "it return all workspaces in the entity" do
      actor, profile, entity = create_user_and_profile
      5.times { workspace_by(profile) }

      get '/workspaces', {}, session_for(profile)

      last_response.status.must_equal 200
      workspaces = JSON.parse(last_response.body)
      workspaces.size.must_equal 5
    end

    outcome "returns a page" do
      actor, profile, entity = create_user_and_profile
      50.times { workspace_by(profile) }

      get '/workspaces?page=1', {}, session_for(profile)

      last_response.status.must_equal 200
      workspaces = JSON.parse(last_response.body)
      workspaces.size.must_equal 20
    end
  end # GET /workspaces

  request "PUT /workspaces/:workspace_id" do
    outcome "updates the workspace" do
      actor, profile, entity = create_user_and_profile
      workspace = workspace_by(profile)
      changes   = { name: "changed" }

      put "/workspaces/#{workspace.fetch('id')}", changes.to_json,
          session_for(profile)

      last_response.status.must_equal 200
      workspace = JSON.parse(last_response.body)
      workspace.fetch('name').must_equal 'changed'
    end

    outcome "presents an errors hash if resource invalid" do
      actor, profile, entity = create_user_and_profile
      workspace = workspace_by(profile)
      changes   = { name: '' }

      put "/workspaces/#{workspace.fetch('id')}", changes.to_json,
          session_for(profile)

      last_response.status.must_equal 400

      workspace = JSON.parse(last_response.body)
      workspace.fetch('errors').wont_be_empty
    end
  end # PUT /workspaces/:workspace_id

  request "DELETE /workspaces/:workspace_id" do
    outcome "deletes the workspace" do
      actor, profile, entity = create_user_and_profile
      workspace = workspace_by(profile)
      delete "/workspaces/#{workspace.fetch('id')}", {}, session_for(profile)

      last_response.status.must_equal 204
      last_response.body  .must_be_empty
    end
  end # DELETE /workspaces/:workspace_id

  request "POST /workspaces/:workspace_id/invitations" do
    outcome "creates an invitation" do
      actor, profile, entity = create_user_and_profile
      workspace = workspace_by(profile)

      invited = Factory.user.sync
      post  "/workspaces/#{workspace.fetch('id')}/invitations",
            { invited_id: invited.id }.to_json, session_for(profile)

      last_response.status.must_equal 201

      invitation = JSON.parse(last_response.body)
      invitation.fetch('state' )     .must_equal 'pending'
    end
  end # POST /workspaces/:workspace_id/invitations

  request "GET /workspaces/:workspace_id/invitations" do
    outcome "gets a page of invitations" do
      actor, profile, entity = create_user_and_profile
      workspace = workspace_by(profile)
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

  request "GET /workspaces/:workspace_id/invitations/:invitation_id" do
    outcome "retrieves an invitation" do
      actor, profile, entity        = create_user_and_profile
      invited_user, invited_profile = create_user_and_profile(entity)

      workspace   = workspace_by(profile)
      invitation  = invitation_for(workspace, profile, invited_user)

      get "/workspaces/#{workspace.fetch('id')}" +
          "/invitations/#{invitation.fetch('id')}",
          {}, session_for(profile)

      last_response.status.must_equal 200
      invitation = JSON.parse(last_response.body)
      invitation.fetch('id').must_equal invitation.fetch('id')
    end
  end # GET /workspaces/:workspace_id/invitations/accepted/:invitation_id

  request "POST /workspaces/:workspace_id/invitations/accepted/:invitation_id" do
    outcome "accepts an invitation" do
      actor, profile, entity        = create_user_and_profile
      invited_user, invited_profile = create_user_and_profile(entity)

      workspace   = workspace_by(profile)
      invitation  = invitation_for(workspace, profile, invited_user)

      post  "/workspaces/#{workspace.fetch('id')}" +
            "/invitations/accepted/#{invitation.fetch('id')}",
            {}, session_for(invited_profile)

      last_response.status.must_equal 200
      invitation = JSON.parse(last_response.body)
      invitation.fetch('state').must_equal 'accepted'
    end
  end # POST /workspaces/:workspace_id/invitations/accepted/:invitation_id

  request "POST /workspaces/:workspace_id/invitations/rejected/:invitation_id" do
    outcome "rejects an invitation" do
      actor, profile, entity        = create_user_and_profile
      invited_user, invited_profile = create_user_and_profile(entity)

      workspace   = workspace_by(profile)
      invitation  = invitation_for(workspace, profile, invited_user)

      post  "/workspaces/#{workspace.fetch('id')}" +
            "/invitations/rejected/#{invitation.fetch('id')}",
            {}, session_for(invited_profile)

      last_response.status.must_equal 200
      invitation = JSON.parse(last_response.body)
      invitation.fetch('state').must_equal 'rejected'
      invitation.fetch('rejected_at').wont_be_empty
    end
  end # POST /workspaces/:workspace_id/invitations/rejected/:invitation_id

  request "POST /workspaces/:workspace_id/autoinvitations" do
    outcome "creates an autoinvitation" do
      actor, profile, entity                  = create_user_and_profile
      autoinvited_actor, autoinvited_profile  = create_user_and_profile(entity)

      workspace = workspace_by(profile)

      post  "/workspaces/#{workspace.fetch('id')}/autoinvitations",
            { autoinvited_id: autoinvited_actor.id }.to_json,
            session_for(autoinvited_profile)

      last_response.status.must_equal 201

      autoinvitation = JSON.parse(last_response.body)
      autoinvitation.fetch('state')  .must_equal 'pending'
    end
  end # POST /workspaces/:workspace_id/autoinvitations

  request "GET /workspaces/:workspace_id/autoinvitations" do
    outcome "gets a page of autoinvitations" do
      actor, profile, entity = create_user_and_profile
      workspace = workspace_by(profile)
      users = (1..50).map do
        autoinvited_actor, autoinvited_profile =
          create_user_and_profile(entity)
        post  "/workspaces/#{workspace.fetch('id')}/autoinvitations",
              { autoinvited_id: autoinvited_actor.id }.to_json,
              session_for(autoinvited_profile)
      end

      get "/workspaces/#{workspace.fetch('id')}/autoinvitations?page=1",
          {}, session_for(profile)

      last_response.status.must_equal 200
      autoinvitations = JSON.parse(last_response.body)
      autoinvitations.size.must_equal 20
    end
  end # GET /workspaces/:workspace_id/autoinvitations

  request "GET /workspaces/:workspace_id
                /autoinvitations/:autoinvitation_id" do
    outcome "retrieves an autoinvitation" do
      actor, profile, entity                = create_user_and_profile
      autoinvited_user, autoinvited_profile = create_user_and_profile(entity)

      workspace       = workspace_by(profile)
      autoinvitation  =
        autoinvitation_for(workspace, autoinvited_profile, autoinvited_user)

      get "/workspaces/#{workspace.fetch('id')}" +
          "/autoinvitations/#{autoinvitation.fetch('id')}",
          {}, session_for(profile)

      last_response.status.must_equal 200
      autoinvitation = JSON.parse(last_response.body)
      autoinvitation.fetch('id').must_equal autoinvitation.fetch('id')
    end
  end # GET /workspaces/:workspace_id/autoinvitations/accepted/:autoinvitation_id

  request "POST  /workspaces/:workspace_id
                  /autoinvitations/accepted/:autoinvitation_id" do
    outcome "accepts an autoinvitation" do
      actor, profile, entity                = create_user_and_profile
      autoinvited_user, autoinvited_profile = create_user_and_profile(entity)

      workspace       = workspace_by(profile)
      autoinvitation  =
        autoinvitation_for(workspace, autoinvited_profile, autoinvited_user)

      post  "/workspaces/#{workspace.fetch('id')}" +
            "/autoinvitations/accepted/#{autoinvitation.fetch('id')}",
            {}, session_for(profile)

      last_response.status.must_equal 200
      autoinvitation = JSON.parse(last_response.body)
      autoinvitation.fetch('state').must_equal 'accepted'
    end
  end # POST /workspaces/:workspace_id/autoinvitations/accepted/:autoinvitation_id

  request "POST /workspaces/:workspace_id
                 /autoinvitations/rejected/:autoinvitation_id" do
    outcome "rejects an autoinvitation" do
      actor, profile, entity                = create_user_and_profile
      autoinvited_user, autoinvited_profile = create_user_and_profile(entity)

      workspace       = workspace_by(profile)
      autoinvitation  =
        autoinvitation_for(workspace, autoinvited_profile, autoinvited_user)

      post  "/workspaces/#{workspace.fetch('id')}" +
            "/autoinvitations/rejected/#{autoinvitation.fetch('id')}",
            {}, session_for(profile)

      last_response.status.must_equal 200
      autoinvitation = JSON.parse(last_response.body)
      autoinvitation.fetch('state').must_equal 'rejected'
    end
  end # POST /workspaces/:workspace_id/autoinvitations/rejected/:autoinvitation_id

  request "POST /workspaces/:workspace_id/administrators/:user_id" do
    outcome 'assigns the administrator role to a existing user in the workspace' do
      administrator, administrator_profile, entity  = create_user_and_profile
      collaborator, collaborator_profile = create_user_and_profile(entity)

      workspace = workspace_by(administrator_profile)

      post  "/workspaces/#{workspace.fetch('id')}" +
            "/administrators/#{collaborator.id}",
            {}, session_for(administrator_profile)

      last_response.status.must_equal 200
      new_administrator = JSON.parse(last_response.body)
      new_administrator.fetch('id').must_equal collaborator.id
    end
  end # POST /workspaces/:workspace_id/admnistrators/:user_id

  request "POST /workspaces/:workspace_id/collaborators/:user_id" do
    outcome 'assigns the collaborator role to a user' do
      administrator, administrator_profile, entity  = create_user_and_profile
      collaborator, collaborator_profile = create_user_and_profile(entity)

      workspace = workspace_by(administrator_profile)

      post  "/workspaces/#{workspace.fetch('id')}" +
            "/collaborators/#{collaborator.id}",
            {}, session_for(administrator_profile)

      last_response.status.must_equal 200
      new_collaborator = JSON.parse(last_response.body)
      new_collaborator.fetch('id').must_equal collaborator.id
    end
  end # POST /workspaces/:workspace_id/collaborators/:user_id

  request "DELETE /workspaces/:workspace_id/collaborators/:user_id" do
    outcome "removes the collaborator from the workspace" do
      administrator, administrator_profile, entity  = create_user_and_profile
      collaborator, collaborator_profile = create_user_and_profile(entity)

      workspace = workspace_by(administrator_profile)

      post  "/workspaces/#{workspace.fetch('id')}" +
            "/collaborators/#{collaborator.id}",
            {}, session_for(administrator_profile)

      delete  "/workspaces/#{workspace.fetch('id')}" +
              "/collaborators/#{collaborator.id}",
              {}, session_for(administrator_profile)

      last_response.status.must_equal 200
    end
  end # DELETE /workspaces/:workspace_id/collaborators/:user_id

  request "DELETE /workspaces/:workspace_id/users/:user_id" do
    outcome 'allows the actor to leave the workspace' do
      administrator, administrator_profile, entity  = create_user_and_profile
      collaborator, collaborator_profile = create_user_and_profile(entity)

      workspace = workspace_by(administrator_profile)

      post  "/workspaces/#{workspace.fetch('id')}" +
            "/collaborators/#{collaborator.id}",
            {}, session_for(administrator_profile)

      delete  "/workspaces/#{workspace.fetch('id')}" +
              "/users/#{collaborator.id}",
              {}, session_for(collaborator_profile)

      last_response.status.must_equal 200
    end
  end # DELETE /workspaces/:workspace_id/users/:user_id

  request "GET /workspaces/:workspace_id/administrators" do
    outcome 'returns a page of administrators in the workspace' do
      administrator, administrator_profile, entity = create_user_and_profile
      workspace = workspace_by(administrator_profile)

      25.times do
        collaborator, collaborator_profile = create_user_and_profile(entity)
        post  "/workspaces/#{workspace.fetch('id')}" +
              "/administrators/#{collaborator.id}",
              {}, session_for(administrator_profile)
      end

      get "/workspaces/#{workspace.fetch('id')}/administrators",
          {}, session_for(administrator_profile)

      last_response.status.must_equal 200
      administrators = JSON.parse(last_response.body)
      administrators.size.must_equal 20
    end
  end # GET /workspaces/:workspace_id/administrators

  request "GET /workspaces/:workspace_id/collaborators" do
    outcome 'returns a page of collaborators in the workspace' do
      administrator, administrator_profile, entity = create_user_and_profile
      workspace = workspace_by(administrator_profile)

      25.times do
        collaborator, collaborator_profile = create_user_and_profile(entity)
        post  "/workspaces/#{workspace.fetch('id')}" +
              "/collaborators/#{collaborator.id}",
              {}, session_for(administrator_profile)
      end

      get "/workspaces/#{workspace.fetch('id')}/collaborators",
          {}, session_for(administrator_profile)

      last_response.status.must_equal 200
      collaborators = JSON.parse(last_response.body)
      collaborators.size.must_equal 20
    end
  end # GET /workspaces/:workspace_id/collaborators

  def invitation_for(workspace, profile, invited)
    invited ||= Factory.user.sync
    post  "/workspaces/#{workspace.fetch('id')}/invitations",
          { invited_id: invited.id }.to_json, session_for(profile)
    invitation = JSON.parse(last_response.body)
  end

  def autoinvitation_for(workspace, profile, user)
    user ||= Factory.user.sync
    post  "/workspaces/#{workspace.fetch('id')}/autoinvitations",
          { autoinvited_id: user.id }.to_json, session_for(profile)
    autoinvitation = JSON.parse(last_response.body)
  end

  def workspace_by(profile)
    name = Factory.random_string
    post "/workspaces", { name: name }.to_json, session_for(profile)
    JSON.parse(last_response.body)
  end
end # API

