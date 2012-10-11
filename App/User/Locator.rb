# encoding: utf-8
require_relative './Member'
require_relative '../../Tinto/Exceptions'

module Belinkr
  module User
    class Locator
      IDS_MAP   = 'users:locator:ids_map'
      KEYS_MAP  = 'users:locator:keys_map'

      def self.add(key, user_id)
        $redis.hset KEYS_MAP, key, user_id
        $redis.hset IDS_MAP, user_id, keys_for(user_id).push(key).to_json
      end

      def self.user_from(key)
        user_id = $redis.hget(KEYS_MAP, key)
        raise Tinto::Exceptions::NotFound unless user_id
        User::Member.new(id: user_id)
      end

      def self.keys_for(user_id)
        JSON.parse($redis.hget(IDS_MAP, user_id) || '[]')
      end

      def self.remove(user_id)
        $redis.hdel KEYS_MAP, keys_for(user_id)
        $redis.hdel IDS_MAP,  user_id
      end

      def self.registered?(user_id)
        !!$redis.hget(IDS_MAP, user_id)
      end
    end # Locator
  end # User
end # Belinkr
