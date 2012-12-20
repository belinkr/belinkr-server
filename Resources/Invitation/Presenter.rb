# encoding: utf-8
require 'json'
require 'Tinto/Presenter'

module Belinkr
  module Invitation
    class Presenter
      def initialize(invitation, scope={})
        @invitation = invitation
      end #initialize

      def as_json(*args)
        as_poro.to_json(*args)
      end #as_json

      def as_poro
        {
          id:             invitation.id,
          invited_name:   invitation.invited_name,
          invited_email:  invitation.invited_email,
          locale:         invitation.locale
        }.merge! Tinto::Presenter.timestamps_for(invitation)
         .merge! Tinto::Presenter.errors_for(invitation)
         .merge! links
      end #as_poro

      private

      attr_reader :invitation

      def links
        invitation_base_path = "/invitations/#{invitation.id}"
        { _links: {
            self:       invitation_base_path,
            inviter:    "/users/#{invitation.inviter_id}"
          }
        }
      end #links
    end # Presenter
  end # Invitation
end # Belinkr

