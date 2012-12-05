# encoding: utf-8
require_relative '../API'
require_relative '../Resources/User/Presenter'
require_relative '../Resources/Invitation/Presenter'
require_relative '../Cases/InvitePersonToBelinkr/Request'
require_relative '../Cases/InvitePersonToBelinkr/Context'
require_relative '../Cases/AcceptInvitationAndJoin/Request'
require_relative '../Cases/AcceptInvitationAndJoin/Context'

module Belinkr
  class API < Sinatra::Base
    get '/invitations/:invitation_id' do
      invitation = Invitation::Member.new(id: params.fetch('invitation_id'))
                     .fetch
      200
    end # GET /invitations/:invitation_id

    post '/invitations' do
      data        = InvitePersonToBelinkr::Request
                      .new(payload, current_user, current_entity).prepare
      invitation  = data.fetch(:invitation)

      dispatch :create, invitation do
        InvitePersonToBelinkr::Context.new(data).run
        invitation
      end
    end # POST /invitations

    put '/invitations/:invitation_id' do
      data  = AcceptInvitationAndJoin::Request.new(combined_input).prepare
      actor = data.fetch(:actor)

      dispatch :update, actor do
        AcceptInvitationAndJoin::Context.new(data).run
        actor
      end
    end # PUT /invitations/:invitation_id
  end # API
end # Belinkr

