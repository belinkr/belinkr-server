# encoding: utf-8
require 'set'
module Belinkr
  module User
    class Locator
      class Buffer
        attr_reader :keys, :ids

        def initialize
          @keys = {}
          @ids  = {}
        end #initialize

        def add(key, user_id)
          @keys[key]    = user_id
          @ids[user_id] = @ids.fetch(user_id, Set.new).add(key)
        end #add

        def delete(user_id)
          @ids.fetch(user_id).each { |key| @keys.delete key }
          @ids.delete user_id
        end #delete

        def id_for(key)
          @keys.fetch(key)
        end #id_for

        def keys_for(user_id)
          @ids.fetch(user_id, [])
        end #keys_for

        def registered?(user_id)
          @ids.has_key?(user_id)
        end #registered?
      end # Buffer
    end # Locator
  end # User
end # Belinkr

