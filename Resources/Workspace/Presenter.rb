# encoding: utf-8
require 'json'
require 'Tinto/Presenter'

module Belinkr
  module Workspace
    class Presenter
      def initialize(workspace, scope={})
        @workspace  = workspace
      end #initialize

      def as_json
        as_poro.to_json
      end #as_json

      def as_poro
        {
          id:         workspace.id,
          name:       workspace.name,
          entity_id:  workspace.entity_id,
        }
          .merge! Tinto::Presenter.timestamps_for(workspace)
          .merge! Tinto::Presenter.errors_for(workspace)
          .merge! counters
          .merge! links
      end

      private

      attr_reader :workspace

      def counters
        { 
          counters: {
            users:    workspace.user_counter,
            statuses: workspace.status_counter
          }
        }
      end #counters

      def links
        { _links: { } }
      end #links
    end # Presenter
  end # Workspace
end # Belinkr

