# encoding: utf-8
require_relative '../../Tinto/Context'

module Belinkr
  class UndeleteInvitation
    include Tinto::Context

    def initialize(arguments)
      @actor        = arguments.fetch(:actor)
      @invitation   = arguments.fetch(:invitation)
      @invitations  = arguments.fetch(:invitations)
    end #initialize

    def call
      invitation.authorize(actor, :undelete)
      invitation.undelete
      invitations.add(invitation)

      will_sync invitation, invitations
    end #call

    private

    attr_reader :actor, :invitation, :invitations, :entity
  end # UndeleteInvitation
end # Belinkr

