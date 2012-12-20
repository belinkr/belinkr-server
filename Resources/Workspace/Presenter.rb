# encoding: utf-8
require 'json'
require 'Tinto/Presenter'
require_relative '../../Services/Tracker'

module Belinkr
  module Workspace
    class Presenter
      def initialize(workspace, scope={})
        @workspace  = workspace
      end #initialize

      def as_json(*args)
        as_poro.to_json(*args)
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
            users:          workspace.user_counter,
            collaborators:  collaborators_counter,
            administrators: administrators_counter,
            statuses:       workspace.status_counter
          }
        }
      end #counters

      def links
        { _links: { } }
      end #links

      def collaborators_counter
        Tracker.new.users_for(workspace, :collaborator).size
      end #collaborators_counter

      def administrators_counter
        Tracker.new.users_for(workspace, :administrator).size
      end #administrators_counter
    end # Presenter
  end # Workspace
end # Belinkr

