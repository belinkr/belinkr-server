# encoding: utf-8
require_relative '../Invitation/Collection'

class DeleteInvitation
  def initialize(actor, invitation, entity)
    @actor        = actor
    @invitation   = invitation
    @entity       = entity
    @invitations  = Invitation::Collection.new(entity_id: @entity.id)
  end

  def call
    $redis.multi do
      @invitation.delete
      @invitations.remove @invitation
    end

    @invitation
  end
end

