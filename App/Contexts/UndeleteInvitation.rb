# encoding: utf-8
require_relative '../Invitation/Collection'
require_relative '../../Tinto/Context'

module Belinkr
  class UndeleteInvitation
    include Tinto::Context

    def initialize(actor, invitation, invitations, entity)
      @actor        = actor
      @entity       = entity
      @invitation   = invitation
      @invitations  = invitations
    end #initialize

    def call
      @invitation.undelete
      @invitations.add @invitation

      @to_sync = [@invitation, @invitations]
      @invitation
    end #call
  end # UndeleteInvitation
end # Belinkr

