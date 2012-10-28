# encoding: utf-8
require 'set'
require_relative './Collection'

module Belinkr
  module Workspace
    module Membership
      class Tracker
        include Enumerable

        def initialize(entity_id, workspace_id)
          @entity_id    = entity_id
          @workspace_id = workspace_id
          @set          = Set.new
        end #initialize

        def add(kind, user_id)
          @set.add serialize(kind, user_id)
        end #add

        def delete(kind, user_id)
          @set.delete serialize(kind, user_id)
        end #delete

        def each
          @set.each { |key| yield Membership::Collection.new(deserialize key) }
        end #each

        def size
          @set.size
        end #raw_keys
  
        private

        def serialize(kind, user_id)
          [@entity_id, @workspace_id, kind, user_id].join(':')
        end #serialize

        def deserialize(key)
          values = key.split(':')
          { 
            entity_id:    values[0], 
            workspace_id: values[1], 
            kind:         values[2], 
            user_id:      values[3]
          }
        end
      end # Tracker
    end # Membership
  end # Workspace
end # Belinkr

