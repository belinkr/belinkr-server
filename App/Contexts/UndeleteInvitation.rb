# encoding: utf-8
require_relative '../Invitation/Collection'

module Belinkr
  class UndeleteInvitation
    def initialize(actor, invitation, entity)
      @actor        = actor
      @invitation   = invitation
      @entity       = entity
      @invitations  = Invitation::Collection.new(entity_id: @entity.id)
    end

    def call
      $redis.multi do
        @invitation.undelete
        @invitations.add @invitation
      end

      @invitation
    end
  end # UndeleteInvitation
end # Belinkr

