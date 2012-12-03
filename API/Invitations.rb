# encoding: utf-8
require_relative "../workspaces"
require_relative "../../app/workspace/invitation/orchestrator"
require_relative "../../app/workspace/invitation/collection"
require_relative "../../app/workspace/invitation/member"
require_relative "../../app/workspace/invitation/presenter"

module Belinkr
  class API < Sinatra::Base
    get "/workspaces/:id/invitations" do
      dispatch :collection do
        Workspace::Invitation::Orchestrator.new(current_user).
          collection(
            Workspace::Member.new(
              id:         params[:id],
              entity_id:  current_user.entity_id
            ),
            Workspace::Invitation::Collection.new(
              entity_id:    current_user.entity_id,
              workspace_id: params[:id]
            ).page(params[:page])
          
          )
      end
    end # get /workspaces/:id/invitations

    get "/workspaces/:id/invitations/:invitation_id" do
      dispatch :read do
        Workspace::Invitation::Orchestrator.new(current_user)
          .read(
            Workspace::Member.new(
              id:         params[:id],
              entity_id:  current_user.entity_id
            ),
            Workspace::Invitation::Member.new(
              id:         params[:invitation_id],
              entity_id:    current_user.entity_id,
              workspace_id: params[:id]
            )
          )
      end
    end # get /workspaces/:id/invitations/:invitation_id

    post "/workspaces/:id/invitations" do
      dispatch :create do
        Workspace::Invitation::Orchestrator.new(current_user)
          .invite(
            Workspace::Member.new(
              id:           params[:id],
              entity_id:    current_user.entity_id
            ),
            Workspace::Invitation::Member.new(
              invited_id:   payload["invited_id"],
              inviter_id:   current_user.id,
              entity_id:    current_user.entity_id,
              workspace_id: params[:id]
            )
          )
      end
    end # post /workspaces/:id/invitations

    put "/workspaces/:id/invitations/accepted/:invitation_id" do
      workspace   = Workspace::Member.new(
                      id:           params[:id],
                      entity_id:    current_user.entity_id
                    )
      invitation  = Workspace::Invitation::Member.new(
                      id:           params[:invitation_id],
                      entity_id:    current_user.entity_id,
                      workspace_id: params[:id]
                    )

      dispatch :update, invitation do
        Workspace::Invitation::Orchestrator.new(current_user)
          .accept(workspace, invitation)
      end
    end # put /workspaces/:id/invitations/accepted

    put "/workspaces/:id/invitations/rejected/:invitation_id" do
      workspace   = Workspace::Member.new(
                      id:           params[:id],
                      entity_id:    current_user.entity_id
                    )
      invitation  = Workspace::Invitation::Member.new(
                      id:           params[:invitation_id],
                      entity_id:    current_user.entity_id,
                      workspace_id: params[:id]
                    )

      dispatch :update, invitation do
        Workspace::Invitation::Orchestrator.new(current_user)
          .reject(workspace, invitation)
      end
    end # put /workspaces/:id/invitations/rejected
  end # API
end # Belinkr
