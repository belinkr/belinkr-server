# encoding: utf-8
require 'json'

module Belinkr
  module User
    class Locator
      class RedisBackend
        KEYS  = 'users:locator:keys'

        def add(key, user_id)
          keys = keys_for(user_id)
          $redis.multi do
            $redis.hset KEYS, key, user_id
            $redis.sadd storage_key_for(user_id), key
          end
        end #add

        def delete(user_id)
          keys_for(user_id).each { |key| $redis.hdel KEYS, key }
          $redis.del storage_key_for(user_id)
        end #delete

        def id_for(key)
          $redis.hget(KEYS, key) || raise(KeyError)
        end #id_for

        def keys_for(user_id)
          $redis.smembers storage_key_for(user_id)
        end #keys_for

        def registered?(user_id)
          ($redis.scard storage_key_for(user_id)) > 0
        end #registered?

        def fetch
          $redis.hgetall(KEYS) || {}
        end #fetch

        private

        def storage_key_for(user_id)
          "users:locator:#{user_id}:keys"
        end
      end # RedisBackend
    end # Locator
  end # User
end # Belinkr
