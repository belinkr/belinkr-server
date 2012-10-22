# encoding: utf-8
require_relative '../../Tinto/Context'

module Belinkr
  class DeleteInvitation
    include Tinto::Context

    def initialize(actor, invitation, invitations, entity)
      @actor        = actor
      @entity       = entity
      @invitation   = invitation
      @invitations  = invitations
    end # initialize

    def call
      @invitation.delete
      @invitations.delete @invitation

      @to_sync = [@invitation, @invitations]
      @invitation
    end # call
  end # DeleteInvitation
end # Belinkr

