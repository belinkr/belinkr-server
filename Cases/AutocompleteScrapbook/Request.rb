# encoding: utf-8
require_relative '../../Services/Searcher'

module Belinkr
  module AutocompleteScrapbook
    class Request
      def initialize(payload, searcher, index_name)
        @payload  = payload
        @searcher_service = searcher
        @index_name = index_name
      end

      def prepare
        results = @searcher_service.autocomplete(
          @index_name, @payload.fetch('q'))

        list = []
        results.each_pair do |redis_key,scrapbook_hash|
          list.push Scrapbook::Member.new scrapbook_hash
        end
        {scrapbooks: list}

      end
    end
  end
end
