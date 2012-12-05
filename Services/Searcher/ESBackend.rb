require_relative './TireWrapper'
module Belinkr
  module User
    class Searcher
      class ESBackend
        include TireWrapper

        def initialize
          index_create "users" 
        end

        def store_user(key, value)
          index_name, hash = transform_input(key, value)
          index_store(index_name, hash)
        end

        def autocomplete(chars)
          result_items = index_search('users', chars)
          transform_output result_items

        end

        def transform_input(key,value)
          #transform from "users:1", {id:1, name:'aaa'}
          #to:
          #index_name = "users"
          #hash={id:1,name:'aaa'}
          index_name = key.split(':')[0..-2].join(':')
          return [index_name, value]
        end

        def transform_output(result_items)
          #from: <Item ...>
          #to: {id:1, name:'abc'}
          hash = {}
          result_items.each do |item|
            source = item["_source"]
            source_id = item["_source"]["id"]
            source = Hash[source.map{|k,v|[k.to_sym,v]}]
            hash.store "users:"+source_id.to_s, source
          end
          hash
        end
      end
    end
  end
end
 

