module Belinkr
  module User
    class Searcher
      class MemoryBackend
        INTERFACE = %w{
          store_user
          autocomplete
        }

        def initialize
          @users = {}
        end

        def store_user(key,value)
          @users.store(key,value)
        end

        def autocomplete(chars)
          @users.select do |k,v|
            v.fetch(:name).match chars
          end
        end

      end
    end
  end
end
 

