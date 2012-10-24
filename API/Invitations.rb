# encoding: utf-8
require_relative '../API'
require_relative '../App/Invitation/Member'
require_relative '../App/Invitation/Collection'
require_relative '../App/Invitation/Presenter'
require_relative '../App/User/Member'
require_relative '../App/Entity/Member'
require_relative '../App/Contexts/InvitePersonToBelinkr'
require_relative '../App/Contexts/AcceptInvitationAndJoinEntity'
require_relative '../App/Contexts/DeleteInvitation'

module Belinkr
  class API < Sinatra::Base
    get '/invitations' do
      dispatch :collection do
        invitations = Invitation::Collection.new(entity_id: current_entity.id)
        invitations.page params[:page]
      end
    end # get /invitations

    get '/invitations/:id' do
      dispatch :read do
        Invitation::Member.new(id: params[:id])
      end
    end # get /invitations/:id

    post '/invitations' do
      invitation  = Invitation::Member.new.update(payload)
      invitations = Invitation::Collection.new(entity_id: current_entity.id)

      dispatch :create, invitation do
        context = InvitePersonToBelinkr.new(
          current_user, invitation, invitations, current_entity
        )
        context.call
        context.sync
        invitation
      end
    end # post /invitations

    put '/invitations/:id' do
      invitation  = Invitation::Member.new(id: params[:id]).fetch
      entity      = Entity::Member.new(id: invitation.entity_id).fetch
      user        = User::Member.new.update(payload)

      dispatch :update, invitation do
        context = AcceptInvitationAndJoinEntity.new(user, invitation, entity)
        context.call
        context.sync
        invitation
      end
    end # put /invitations/:id

    delete '/invitations/:id' do
      invitation = Invitation::Member.new(
        id: params[:id], entity_id: current_entity.id
      ).fetch
      invitations = Invitation::Collection.new(entity_id: current_entity.id)
    
      dispatch :delete, invitation do
        context = DeleteInvitation
                    .new(current_user, invitation, invitations, current_entity)
        context.call
        context.sync
        invitation
      end
    end # delete /invitations/:id
  end # API
end # Belinkr
