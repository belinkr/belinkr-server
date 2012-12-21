# encoding: utf-8
require_relative '../../Services/Searcher'

module Belinkr
  module AutocompleteWorkspace
    class Request
      def initialize(payload, current_entity_id, searcher, index_name)
        @payload  = payload
        @searcher_service = searcher
        @index_name = index_name
        @current_entity_id = current_entity_id
      end

      def prepare
        results = @searcher_service .autocomplete(
          @index_name, @payload.fetch('q'), {:entity_id =>[@current_entity_id]})

        list = []
        results.each_pair do |redis_key,workspace_hash|
          list.push Workspace::Member.new workspace_hash
        end
        {workspaces: list}

      end
    end
  end
end
