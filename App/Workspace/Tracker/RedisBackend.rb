# encoding: utf-8

module Belinkr
  module Workspace
    module Membership
      class Tracker
        class RedisBackend
          def initialize(storage_key)
            @storage_key = storage_key
          end #initialize

          def add(element)
            $redis.sadd @storage_key, element
          end #add

          def delete(element)
            $redis.srem @storage_key, element
          end #delete

          def fetch
            $redis.smembers @storage_key
          end #fetch

          def size
            $redis.scard @storage_key
          end #size
        end # RedisBackend
      end # Tracker
    end # Membership
  end # Workspace
end # Belinkr
