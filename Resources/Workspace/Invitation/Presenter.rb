# encoding: utf-8
require 'json'
require 'Tinto/Presenter'

module Belinkr
  module Workspace
    module Invitation
      class Presenter
        def initialize(invitation, actor=nil)
          @invitation = invitation
          @actor      = actor
        end #initialize

        def as_json
          as_poro.to_json
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

        attr_reader :invitation, :actor
      end # Presenter
    end # Invitation
  end # Workspace
end # Belinkr

