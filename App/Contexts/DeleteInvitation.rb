# encoding: utf-8
require_relative '../../Tinto/Context'

module Belinkr
  class DeleteInvitation
    include Tinto::Context

    def initialize(arguments)
      @actor        = arguments.fetch(:actor)
      @invitation   = arguments.fetch(:invitation)
      @invitations  = arguments.fetch(:invitations)
    end # initialize

    def call
      invitation.authorize(actor, :delete)
      invitation.delete
      invitations.delete invitation

      will_sync invitation, invitations
    end # call

    private

    attr_reader :actor, :invitation, :invitations
  end # DeleteInvitation
end # Belinkr

