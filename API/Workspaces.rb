# encoding: utf-8
require_relative "../api"
require_relative "workspaces/invitations"
require_relative "workspaces/autoinvitations"
require_relative "workspaces/users"
require_relative "workspaces/statuses"
require_relative "workspaces/replies"

require_relative '../api'
require_relative '../app/workspace/orchestrator'
require_relative '../app/workspace/collection'
require_relative '../app/workspace/member'
require_relative '../app/workspace/presenter'

require_relative '../app/workspace/summary/member'
require_relative '../app/workspace/summary/presenter'
require_relative '../app/workspace/retriever'

module Belinkr
  class API < Sinatra::Base
    #fake workspace searcher
    get "/workspaces/autocomplete" do
      name = params[:name]
      page = params[:page].to_i || 0
      perPage = params[:perPage].to_i || 20
      query = {name: name}
      retriever = Workspace::Retriever.new(current_user.entity_id,
                                           query, page, perPage)
      retriever.search
      [200,retriever.results.to_json]
    end

    #fake workspace searcher
    get "/workspaces/search" do
      name = params[:name]
      page = params[:page].to_i || 0
      perPage = params[:perPage].to_i || 20
      query = {name: name}
      retriever = Workspace::Retriever.new(current_user.entity_id,
                                           query, page, perPage)
      dispatch :collection do
        Workspace::Orchestrator.new(current_user).collection(
          retriever.search_collection
        )
      end

    end

    get "/workspaces" do
      dispatch :collection do
        Workspace::Orchestrator.new(current_user).collection(
          Workspace::Collection
            .new(entity_id: current_user.entity_id)
            .page(params[:page])
        )
      end
    end # get /workspaces

    get "/workspaces/own" do
      dispatch :collection do
        Workspace::Orchestrator.new(current_user).collection(
          Workspace::Membership::Collection.new(
            kind:       :own,
            user_id:    current_user.id,
            entity_id:  current_user.entity_id
          )
          .page_size(params[:perPage])
          .page(params[:page])
        )
      end
    end

    get "/workspaces/autoinvited" do
      dispatch :collection do
        Workspace::Orchestrator.new(current_user).collection(
          Workspace::Membership::Collection.new(
            kind:       :autoinvited,
            user_id:    current_user.id,
            entity_id:  current_user.entity_id
          )
          .page(params[:page])
        )
      end
    end

    get "/workspaces/invited" do
      dispatch :collection do
        Workspace::Orchestrator.new(current_user).collection(
          Workspace::Membership::Collection.new(
            kind:       :invited,
            user_id:    current_user.id,
            entity_id:  current_user.entity_id
          ).page(params[:page])
        )
      end
    end

    get "/workspaces/:id" do
      dispatch :read do
        Workspace::Orchestrator.new(current_user).read(
         Workspace::Member
          .new(id: params[:id], entity_id: current_user.entity_id)
        )
      end
    end # get /workspaces/:id

    get "/workspaces/:id/summary" do
      dispatch :read do
        workspace = Workspace::Orchestrator.new(current_user).read(
          Workspace::Member
           .new(id: params[:id], entity_id: current_user.entity_id)
        )
        Workspace::Summary::Member.new(workspace, current_user)
      end
    end # get /workspaces/:id/summary

    post "/workspaces" do
      payload.delete("id")
      payload.merge(entity_id: current_user.entity_id)

      workspace = Workspace::Member.new(payload)
      dispatch :create, workspace do
        Workspace::Orchestrator.new(current_user).create(workspace)
      end
    end # post /workspaces/:id

    put "/workspaces/:id" do
      payload.delete("id")
      payload.merge!(entity_id: current_user.entity_id)

      workspace = Workspace::Member.new(
                    id:         params[:id],
                    entity_id:  current_user.entity_id
                  )
      changes    = Workspace::Member.new(payload)
      changes.id = workspace.id

      dispatch :update, workspace do
        Workspace::Orchestrator.new(current_user).update(workspace, changes)
      end
    end # put /workspaces/:id
    
    delete "/workspaces/:id" do
      workspace = Workspace::Member.new(
                    id:         params[:id],
                    entity_id:  current_user.entity_id
                  )
      
      dispatch :delete do
        Workspace::Orchestrator.new(current_user).delete(workspace)
      end
    end
  end # API
end # Belinkr
# encoding: utf-8
require_relative "../workspaces"
require_relative "../../app/workspace/autoinvitation/orchestrator"
require_relative "../../app/workspace/autoinvitation/collection"
require_relative "../../app/workspace/autoinvitation/member"
require_relative "../../app/workspace/autoinvitation/presenter"

module Belinkr
  class API < Sinatra::Base
    get "/workspaces/:id/autoinvitations" do
      dispatch :collection do
        Workspace::Autoinvitation::Orchestrator.new(current_user).
          collection(
            Workspace::Member.new(
              id:         params[:id],
              entity_id:  current_user.entity_id
            ),
            Workspace::Autoinvitation::Collection.new(
              entity_id:    current_user.entity_id,
              workspace_id: params[:id]
            ).page(params[:page])
          
          )
      end
    end # get /workspaces/:id/autoinvitations

    get "/workspaces/:id/autoinvitations/:autoinvitation_id" do
      dispatch :read do
        Workspace::Autoinvitation::Orchestrator.new(current_user)
          .read(
            Workspace::Member.new(
              id:         params[:id],
              entity_id:  current_user.entity_id
            ),
            Workspace::Autoinvitation::Member.new(
              id:         params[:autoinvitation_id],
              entity_id:    current_user.entity_id,
              workspace_id: params[:id]
            )
          )
      end
    end # get /workspaces/:id/autoinvitations/:autoinvitation_id

    post "/workspaces/:id/autoinvitations" do
      dispatch :create do
        Workspace::Autoinvitation::Orchestrator.new(current_user)
          .request(
            Workspace::Member.new(
              id:           params[:id],
              entity_id:    current_user.entity_id
            ),
            Workspace::Autoinvitation::Member.new(
              invited_id:   current_user.id,
              entity_id:    current_user.entity_id,
              workspace_id: params[:id]
            )
          )
      end
    end # post /workspaces/:id/autoinvitations

    put "/workspaces/:id/autoinvitations/accepted/:autoinvitation_id" do
      workspace   = Workspace::Member.new(
                      id:           params[:id],
                      entity_id:    current_user.entity_id
                    )
      autoinvitation  = Workspace::Autoinvitation::Member.new(
                      id:           params[:autoinvitation_id],
                      entity_id:    current_user.entity_id,
                      workspace_id: params[:id]
                    )

      dispatch :update, autoinvitation do
        Workspace::Autoinvitation::Orchestrator.new(current_user)
          .accept(workspace, autoinvitation)
      end
    end # put /workspaces/:id/autoinvitations/accepted

    put "/workspaces/:id/autoinvitations/rejected/:autoinvitation_id" do
      workspace   = Workspace::Member.new(
                      id:           params[:id],
                      entity_id:    current_user.entity_id
                    )
      autoinvitation  = Workspace::Autoinvitation::Member.new(
                      id:           params[:autoinvitation_id],
                      entity_id:    current_user.entity_id,
                      workspace_id: params[:id]
                    )

      dispatch :update, autoinvitation do
        Workspace::Autoinvitation::Orchestrator.new(current_user)
          .reject(workspace, autoinvitation)
      end
    end # put /workspaces/:id/autoinvitations/rejected
  end # API
end # Belinkr
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
