# encoding: utf-8
require_relative '../API'
require_relative '../App/Invitation/Member'
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
        Invitation::Collection.new(entity_id: current_entity.id)
          .page(params[:page])
      end
    end # get /invitations

    get '/invitations/:id' do
      dispatch :read do
        Invitation::Member.new(id: params[:id])
      end
    end # get /invitations/:id

    post '/invitations' do
      payload.delete("id")
      invitation = Invitation::Member.new(payload)

      dispatch :create, invitation do
        InvitePersonToBelinkr.new(current_user, invitation, current_entity)
          .call
      end
    end # post /invitations

    put '/invitations/:id' do
      attributes  = payload
      attributes.delete("id")

      invitation  = Invitation::Member.new(id: params[:id])
      user        = User::Member.new(attributes)
      entity      = Entity::Member.new(id: invitation.entity_id)

      dispatch :update, invitation do
        AcceptInvitationAndJoinEntity.new(user, invitation, entity)
          .call
      end
    end # put /invitations/:id

    delete '/invitations/:id' do
      invitation = Invitation::Member
                    .new(id: params[:id], entity_id: current_entity.id)
    
      dispatch :delete, invitation do
        DeleteInvitation.new(current_user, invitation, current_entity).call
      end
    end # delete /invitations/:id
  end # API
end # Belinkr
