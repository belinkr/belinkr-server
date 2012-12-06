require 'json'
require_relative './TireWrapper'
module Belinkr
  class Searcher
    class ESBackend
      include TireWrapper

      def initialize(index_name)
        @index_name = index_name
        index_create @index_name 
      end

      def store(key, value)
        index_name, hash = transform_input(key, value)
        index_store(index_name, hash)
      end

      def autocomplete(index_name, chars)
        result_items = index_search(index_name, chars)
        transform_output result_items

      end

      private
      #transform from "users:1", {id:1, name:'aaa'}
      #to:
      #index_name = "users"
      #hash={id:1,name:'aaa'}
      def transform_input(key,value)
        index_name = key.split(':')[0..-2].join(':')
        [index_name, value]
      end
      
      #from: <Item ...>
      #to: {id:1, name:'abc'}
      def transform_output(result_items)
        hash = {}
        result_items.each do |item|
          source = item.fetch "_source"
          source_id = source.fetch "id"
          str_key = @index_name + ":" + source_id.to_s
          source = JSON.parse(item.to_json, :symbolize_names => true)
            .fetch :_source
          hash.store str_key, source
        end
        hash
      end
    end
  end
end
 

