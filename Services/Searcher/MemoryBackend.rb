module Belinkr
  class Searcher
    class MemoryBackend
      INTERFACE = %w{
        store
        autocomplete
      }

      attr_reader :storage
      def initialize(index_name)
        @index_name = index_name
        @storage = {}
        @storage[index_name] ={}
      end

      def store(key,value)
        @storage.fetch(@index_name).store(key,value)
      end

      def autocomplete(index_name, chars)
        @storage.fetch(@index_name).select do |k,v|
          v.fetch(:name).match chars
        end
      end

    end
  end
end
 

