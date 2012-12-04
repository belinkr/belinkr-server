# encoding: utf-8
require 'json'
require 'Tinto/Presenter'

module Belinkr
  module Workspace
    module Autoinvitation
      class Presenter
        def initialize(autoinvitation, actor=nil)
          @autoinvitation = autoinvitation
          @actor          = actor
        end #initialize

        def as_json
          as_poro.to_json
        end #as_json

        def as_poro
          {
            id:                 autoinvitation.id,
            state:              autoinvitation.state,
            rejected_at:        autoinvitation.rejected_at
          }
           .merge! Tinto::Presenter.timestamps_for(autoinvitation)
           .merge! Tinto::Presenter.errors_for(autoinvitation)
        end #as_poro

        private

        attr_reader :autoinvitation, :actor
      end # Presenter
    end # Autoinvitation
  end # Workspace
end # Belinkr

