require 'json'
module Belinkr
  class Searcher
    class RedisBackend
      def initialize(index_name)
        @index_name = index_name
      end

      def store(key, value)
        $redis.set key, value.to_json

      end

      def autocomplete(index_name, chars, filter_hash=nil)
        keys = $redis.keys index_name + ':*'
        results ={}
        keys.each do |key|
          next unless $redis.type(key) == 'string'
          value = JSON.parse $redis.get(key), :symbolize_names => true
          results[key]= value if value.fetch(:name).match chars
        end
        results
      end

    end
  end
end
 
