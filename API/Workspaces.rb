# encoding: utf-8
require_relative '../API'
require_relative '../Resources/User/Presenter'
require_relative '../Resources/Workspace/Presenter'
require_relative '../Resources/Workspace/Invitation/Presenter'
require_relative '../Resources/Workspace/Autoinvitation/Presenter'

require_relative '../Cases/CreateWorkspace/Request'
require_relative '../Cases/CreateWorkspace/Context'
require_relative '../Cases/EditWorkspace/Request'
require_relative '../Cases/EditWorkspace/Context'
require_relative '../Cases/DeleteWorkspace/Request'
require_relative '../Cases/DeleteWorkspace/Context'

require_relative '../Cases/AssignCollaboratorRoleInWorkspace/Request'
require_relative '../Cases/AssignCollaboratorRoleInWorkspace/Context'
require_relative '../Cases/AssignAdministratorRoleInWorkspace/Request'
require_relative '../Cases/AssignAdministratorRoleInWorkspace/Context'

require_relative '../Cases/LeaveWorkspace/Request'
require_relative '../Cases/LeaveWorkspace/Context'
require_relative '../Cases/RemoveUserFromWorkspace/Request'
require_relative '../Cases/RemoveUserFromWorkspace/Context'

require_relative '../Cases/InviteUserToWorkspace/Request'
require_relative '../Cases/InviteUserToWorkspace/Context'
require_relative '../Cases/AcceptInvitationToWorkspace/Request'
require_relative '../Cases/AcceptInvitationToWorkspace/Context'
require_relative '../Cases/RejectInvitationToWorkspace/Request'
require_relative '../Cases/RejectInvitationToWorkspace/Context'

require_relative '../Cases/AutoinviteToWorkspace/Request'
require_relative '../Cases/AutoinviteToWorkspace/Context'
require_relative '../Cases/AcceptAutoinvitationToWorkspace/Request'
require_relative '../Cases/AcceptAutoinvitationToWorkspace/Context'
require_relative '../Cases/RejectAutoinvitationToWorkspace/Request'
require_relative '../Cases/RejectAutoinvitationToWorkspace/Context'

module Belinkr
  class API < Sinatra::Base
    get '/workspaces' do
      dispatch :collection do
        Workspace::Collection.new(entity_id: current_entity.id)
          .page(params.fetch('page', 0))
      end
    end # get /workspaces

    get '/workspaces/own' do
      dispatch :collection do
        Workspace::Tracker.new.workspaces_for(current_user, :member)
          .page(params.fetch('page', 0))
      end
    end # get /workspaces/own

    get '/workspaces/autoinvited' do
      dispatch :collection do
        Workspace::Tracker.new.workspaces_for(current_user, :autoinvited)
          .page(params.fetch('page', 0))
      end
    end # get /workspaces/autoinvited

    get '/workspaces/invited' do
      dispatch :collection do
        Workspace::Tracker.new.workspaces_for(current_user, :invited)
          .page(params.fetch('page', 0))
      end
    end # get /workspaces/invited

    get '/workspaces/:workspace_id' do
      dispatch :read do
        Workspace::Member.new(
          id:         params.fetch('workspace_id'),
          entity_id:  current_entity.id
        ).fetch
      end
    end # get /workspaces/:workspace_id

    post '/workspaces' do
      data = CreateWorkspace::Request
              .new(payload, current_user, current_entity).prepare
      workspace = data.fetch(:workspace)

      dispatch :create, workspace do
        CreateWorkspace::Context.new(data).run
        workspace
      end
    end # post /workspaces

    put '/workspaces/:workspace_id' do
      data = EditWorkspace::Request
              .new(combined_input, current_user, current_entity).prepare
      workspace = data.fetch(:workspace)
      dispatch :update, workspace do
        EditWorkspace::Context.new(data).run
        workspace
      end
    end # put /workspaces/:workspace_id
    
    delete '/workspaces/:workspace_id' do
      data = DeleteWorkspace::Request
              .new(params, current_user, current_entity).prepare
      workspace = data.fetch(:workspace)

      dispatch :delete, workspace do
        DeleteWorkspace::Context.new(data).run
        workspace
      end
    end # delete /workspaces

    get '/workspaces/:workspace_id/invitations' do
      dispatch :collection do
        Workspace::Invitation::Collection.new(
          workspace_id: params.fetch('workspace_id'),
          entity_id:    current_entity.id
        ).page(params.fetch('page', 0))
      end
    end # get /workspaces/:workspace_id/invitations

    get '/workspaces/:workspace_id/invitations/:invitation_id' do
      dispatch :read do
        Workspace::Invitation::Member.new(
          id:           params.fetch('invitation_id'),
          workspace_id: params.fetch('workspace_id'),
          entity_id:    current_entity.id
        )
      end
    end # get /workspaces/:workspace_id/invitations/:invitation_id

    post '/workspaces/:workspace_id/invitations' do
      data = InviteUserToWorkspace::Request
              .new(combined_input, current_user, current_entity).prepare
      invitation = data.fetch(:invitation)

      dispatch :create, invitation do
        InviteUserToWorkspace::Context.new(data).run
        invitation
      end
    end # post /workspaces/:workspace_id/invitations

    post '/workspaces/:workspace_id/invitations/accepted/:invitation_id' do
      data = AcceptInvitationToWorkspace::Request
              .new(params, current_user, current_entity).prepare
      invitation = data.fetch(:invitation)

      dispatch :update, invitation do
        AcceptInvitationToWorkspace::Context.new(data).run
        invitation
      end
    end # post /workspaces/:workspace_id/invitations/accepted/:invitation_id

    post '/workspaces/:workspace_id/invitations/rejected/:invitation_id' do
      data = RejectInvitationToWorkspace::Request
              .new(params, current_user, current_entity).prepare
      invitation = data.fetch(:invitation)

      dispatch :update, invitation do
        RejectInvitationToWorkspace::Context.new(data).run
        invitation
      end
    end # post /workspaces/:workspace_id/invitations/rejected/:invitation_id

    get '/workspaces/:workspace_id/autoinvitations' do
      dispatch :collection do
        Workspace::Autoinvitation::Collection.new(
          workspace_id: params.fetch('workspace_id'),
          entity_id:    current_entity.id
        ).page(params.fetch('page', 0))
      end
    end # get /workspaces/:workspace_id/autoinvitations

    get '/workspaces/:workspace_id/autoinvitations/:autoinvitation_id' do
      dispatch :read do
        Workspace::Autoinvitation::Member.new(
          id:           params.fetch('autoinvitation_id'),
          workspace_id: params.fetch('workspace_id'),
          entity_id:    current_entity.id
        )
      end
    end # get /workspaces/:workspace_id/autoinvitations/:autoinvitation_id

    post '/workspaces/:workspace_id/autoinvitations' do
      data = AutoinviteToWorkspace::Request
              .new(combined_input, current_user, current_entity).prepare
      autoinvitation = data.fetch(:autoinvitation)

      dispatch :create, autoinvitation do
        AutoinviteToWorkspace::Context.new(data).run
        autoinvitation
      end
    end # post /workspaces/:workspace_id/autoinvitations

    post '/workspaces/:workspace_id/autoinvitations/accepted/:autoinvitation_id' do
      data = AcceptAutoinvitationToWorkspace::Request
              .new(params, current_user, current_entity).prepare
      autoinvitation = data.fetch(:autoinvitation)

      dispatch :update, autoinvitation do
        AcceptAutoinvitationToWorkspace::Context.new(data).run
        autoinvitation
      end
    end # post /workspaces/:workspace_id/autoinvitations/accepted

    post '/workspaces/:workspace_id/autoinvitations/rejected/:autoinvitation_id' do
      data = RejectAutoinvitationToWorkspace::Request
              .new(params, current_user, current_entity).prepare
      autoinvitation = data.fetch(:autoinvitation)

      dispatch :update, autoinvitation do
        RejectAutoinvitationToWorkspace::Context.new(data).run
        autoinvitation
      end
    end # post /workspaces/:workspace_id/autoinvitations/rejected

    post '/workspaces/:workspace_id/administrators/:user_id' do
      data = AssignAdministratorRoleInWorkspace::Request
              .new(params, current_user, current_entity).prepare
      target_user = data.fetch(:target_user)

      dispatch :update, target_user do
        AssignAdministratorRoleInWorkspace::Context.new(data).run
        target_user
      end
    end # post /workspaces/:workspace_id/administrators/:user_id

    post '/workspaces/:workspace_id/collaborators/:user_id' do
      data = AssignCollaboratorRoleInWorkspace::Request
              .new(params, current_user, current_entity).prepare
      target_user = data.fetch(:target_user)

      dispatch :update, target_user do
        AssignCollaboratorRoleInWorkspace::Context.new(data).run
        target_user
      end
    end # post /workspaces/:workspace_id/collaborators/:user_id

    delete '/workspaces/:workspace_id/collaborators/:user_id' do
      data = RemoveUserFromWorkspace::Request
              .new(params, current_user, current_entity).prepare
      target_user = data.fetch(:target_user)

      dispatch :update, target_user do
        RemoveUserFromWorkspace::Context.new(data).run
        target_user
      end
    end # delete /workspaces/:workspace_id/collaborators/:user_id

    delete '/workspaces/:workspace_id/users/:user_id' do
      data = LeaveWorkspace::Request
              .new(params, current_user, current_entity).prepare
      actor = data.fetch(:actor)

      dispatch :update, actor do
        LeaveWorkspace::Context.new(data).run
        actor
      end
    end # delete /workspaces/:workspace_id/users/:user_id

    get '/workspaces/:workspace_id/collaborators' do
      dispatch :collection do
        workspace = Workspace::Member.new(
          id:     params.fetch('workspace_id'), 
          entity: current_entity.id
        )
        tracker   = Workspace::Tracker.new
        tracker.users_for(workspace, :collaborator)
          .page(params.fetch('page', 0))
      end
    end # get '/workspaces/:workspace_id/collaborators'

    get '/workspaces/:workspace_id/administrators' do
      dispatch :collection do
        workspace = Workspace::Member.new(
          id:     params.fetch('workspace_id'), 
          entity: current_entity.id
        )
        tracker   = Workspace::Tracker.new
        tracker.users_for(workspace, :administrator)
          .page(params.fetch('page', 0))
      end
    end # get '/workspaces/:workspace_id/administrators'
  end # API
end # Belinkr

