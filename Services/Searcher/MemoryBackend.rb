module Belinkr
  class Searcher
    class MemoryBackend
      INTERFACE = %w{
        store_user
        autocomplete
      }

      def initialize(index_name)
        class << self
          self
        end.class_eval do
          attr_reader index_name
        end
        instance_variable_set("@users",{})
      end

      def store_user(key,value)
        @users.store(key,value)
      end

      def autocomplete(index_name, chars)
        instance_variable_get('@'+index_name).select do |k,v|
          v.fetch(:name).match chars
        end
      end

    end
  end
end
 

