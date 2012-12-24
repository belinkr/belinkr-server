# encoding: utf-8
require 'json'
require 'Tinto/Presenter'

module Belinkr
  module Workspace
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
            id:           invitation.id,
            state:        invitation.state,
            rejected_at:  invitation.rejected_at
          }
           .merge! Tinto::Presenter.timestamps_for(invitation)
           .merge! Tinto::Presenter.errors_for(invitation)
        end #as_poro

        private

        attr_reader :invitation
      end # Presenter
    end # Invitation
  end # Workspace
end # Belinkr

