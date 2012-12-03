# encoding: utf-8
require_relative '../API'
require_relative '../Resources/Workspace/Member'
require_relative '../Resources/Workspace/Collection'
require_relative '../Resources/Workspace/Enforcer'
require_relative '../Resources/Workspace/Presenter'
require_relative '../Resources/Workspace/Invitation/Presenter'
require_relative '../Resources/Workspace/Autoinvitation/Presenter'

require_relative '../Cases/CreateWorkspace/Request'
require_relative '../Cases/CreateWorkspace/Context'
require_relative '../Cases/EditWorkspace/Request'
require_relative '../Cases/EditWorkspace/Context'
require_relative '../Cases/DeleteWorkspace/Request'
require_relative '../Cases/DeleteWorkspace/Context'

require_relative '../Cases/InviteUserToWorkspace/Request'
require_relative '../Cases/InviteUserToWorkspace/Context'
require_relative '../Cases/AcceptInvitationToWorkspace/Request'
require_relative '../Cases/AcceptInvitationToWorkspace/Context'
require_relative '../Cases/RejectInvitationToWorkspace/Request'
require_relative '../Cases/RejectInvitationToWorkspace/Context'

require_relative '../Cases/AutoinviteToWorkspace/Request'
require_relative '../Cases/AutoinviteToWorkspace/Context'

module Belinkr
  class API < Sinatra::Base
    get "/workspaces" do
      dispatch :collection do
        Workspace::Collection.new(entity_id: current_entity.id)
          .page(params.fetch('page', 0))
      end
    end # get /workspaces

    get "/workspaces/own" do
    end # get /workspaces/own

    get "/workspaces/autoinvited" do
    end # get /workspaces/autoinvited

    get "/workspaces/invited" do
    end # get /workspaces/invited

    get "/workspaces/:workspace_id" do
      dispatch :read do
        Workspace::Member.new(
          id:         params.fetch('workspace_id'),
          entity_id:  current_entity.id
        ).fetch
      end
    end # get /workspaces/:workspace_id

    post "/workspaces" do
      data = CreateWorkspace::Request
              .new(payload, current_user, current_entity).prepare
      workspace = data.fetch(:workspace)

      dispatch :create, workspace do
        CreateWorkspace::Context.new(data).run
        workspace
      end
    end # post /workspaces

    put "/workspaces/:workspace_id" do
      data = EditWorkspace::Request
              .new(combined_input, current_user, current_entity).prepare
      workspace = data.fetch(:workspace)
      dispatch :update, workspace do
        EditWorkspace::Context.new(data).run
        workspace
      end
    end # put /workspaces/:workspace_id
    
    delete "/workspaces/:workspace_id" do
      data = DeleteWorkspace::Request
              .new(params, current_user, current_entity).prepare
      workspace = data.fetch(:workspace)

      dispatch :delete, workspace do
        DeleteWorkspace::Context.new(data).run
        workspace
      end
    end # delete /workspaces

    get "/workspaces/:workspace_id/invitations" do
      dispatch :collection do
        Workspace::Invitation::Collection.new(
          workspace_id: params.fetch('workspace_id'),
          entity_id:    current_entity.id
        ).page(params.fetch('page', 0))
      end
    end # get /workspaces/:workspace_id/invitations

    get "/workspaces/:workspace_id/invitations/:invitation_id" do
      dispatch :read do
        Workspace::Invitation::Member.new(
          id:           params.fetch('invitation_id'),
          workspace_id: params.fetch('workspace_id'),
          entity_id:    current_entity.id
        )
      end
    end # get /workspaces/:workspace_id/invitations/:invitation_id

    post "/workspaces/:workspace_id/invitations" do
      data = InviteUserToWorkspace::Request
              .new(combined_input, current_user, current_entity).prepare
      invitation = data.fetch(:invitation)

      dispatch :create, invitation do
        InviteUserToWorkspace::Context.new(data).run
        invitation
      end
    end # post /workspaces/:workspace_id/invitations

    post "/workspaces/:workspace_id/invitations/accepted/:invitation_id" do
      data = AcceptInvitationToWorkspace::Request
              .new(params, current_user, current_entity).prepare
      invitation = data.fetch(:invitation)

      dispatch :update, invitation do
        AcceptInvitationToWorkspace::Context.new(data).run
        invitation
      end
    end # post /workspaces/:workspace_id/invitations/accepted/:invitation_id

    post "/workspaces/:workspace_id/invitations/rejected/:invitation_id" do
      data = RejectInvitationToWorkspace::Request
              .new(params, current_user, current_entity).prepare
      invitation = data.fetch(:invitation)

      dispatch :update, invitation do
        RejectInvitationToWorkspace::Context.new(data).run
        invitation
      end
    end # post /workspaces/:workspace_id/invitations/rejected/:invitation_id

    get "/workspaces/:workspace_id/autoinvitations" do
      dispatch :collection do
        Workspace::Autoinvitation::Collection.new(
          workspace_id: params.fetch('workspace_id'),
          entity_id:    current_entity.id
        ).page(params.fetch('page', 0))
      end
    end # get /workspaces/:workspace_id/autoinvitations

    get "/workspaces/:workspace_id/autoinvitations/:autoinvitation_id" do
    end # get /workspaces/:workspace_id/autoinvitations/:autoinvitation_id

    post "/workspaces/:workspace_id/autoinvitations" do
      data = AutoinviteToWorkspace::Request
              .new(combined_input, current_user, current_entity).prepare
      autoinvitation = data.fetch(:autoinvitation)

      dispatch :create, autoinvitation do
        AutoinviteToWorkspace::Context.new(data).run
        autoinvitation
      end
    end # post /workspaces/:workspace_id/autoinvitations

    post "/workspaces/:workspace_id/autoinvitations/accepted" do
    end # post /workspaces/:workspace_id/autoinvitations/accepted

    post "/workspaces/:workspace_id/autoinvitations/rejected" do
    end # post /workspaces/:workspace_id/autoinvitations/rejected
  end # API
end # Belinkr

