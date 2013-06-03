# encoding: utf-8
require 'json'
require 'Tinto/Presenter'

module Belinkr
  module Workspace
    module Autoinvitation
      class Presenter
        def initialize(autoinvitation, scope={})
          @autoinvitation = autoinvitation
        end #initialize

        def as_json(*args)
          as_poro.to_json(*args)
        end #as_json

        def as_poro
          {
            id:           autoinvitation.id,
            autoinvited_id: autoinvitation.autoinvited_id,
            autoinvited_name: autoinvitation.autoinvited_name,
            state:        autoinvitation.state,
            rejected_at:  autoinvitation.rejected_at
          }
           .merge! Tinto::Presenter.timestamps_for(autoinvitation)
           .merge! Tinto::Presenter.errors_for(autoinvitation)
        end #as_poro

        private

        attr_reader :autoinvitation
      end # Presenter
    end # Autoinvitation
  end # Workspace
end # Belinkr

