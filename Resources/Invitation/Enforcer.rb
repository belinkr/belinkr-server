# encoding: utf-8
require 'Tinto/Exceptions'

module Belinkr
  module Invitation
    class Enforcer
      include Tinto::Exceptions

      def initialize(invitation)
        @invitation = invitation
      end #invitation

      def authorize(actor, action)
        raise NotAllowed unless invitation.inviter_id == actor.id
        return true
      end #authorize

      private

      attr_reader :invitation
    end # Enforcer
  end # Invitation
end # Belinkr

