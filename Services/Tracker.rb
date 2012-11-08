# encoding: utf-8
require 'set'
require_relative './Tracker/RedisBackend'
require_relative '../Data/Workspace/Membership/Collection'

module Belinkr
  module Workspace
    class Tracker
      include Enumerable

      def initialize(entity_id, workspace_id)
        @entity_id        = entity_id
        @workspace_id     = workspace_id
        @buffered_set     = Set.new
        @persisted_set    = RedisBackend.new(storage_key)
        @current_backend  = @persisted_set
        @backlog          = []
      end #initialize

      def in_memory?
        @current_backend == @buffered_set
      end #in_memory?

      def reset(tuples=[])
        @backlog.clear
        @buffered_set = Set.new 
        tuples.map { |tuple| add(*tuple) }
        @current_backend = @buffered_set
        self
      end #reset

      def sync
        $redis.multi { @backlog.each { |command| command.call } }
        @backlog.clear
        self
      end #sync

      def synced?
        @backlog.empty?
      end #synced?

      def fetch
        @backlog.clear
        @buffered_set     = Set.new @persisted_set.fetch
        @current_backend  = @buffered_set
        self
      end #fetch

      def fetched?
        @current_backend == @buffered_set
      end #fetched?

      alias_method :in_memory?, :fetched?

      def add(kind, user_id)
        element = serialize(kind, user_id)
        @backlog.push(lambda { @persisted_set.add element })
        @buffered_set.add element
        self
      end #add

      def delete(kind, user_id)
        element = serialize(kind, user_id)
        @backlog.push(lambda { @persisted_set.delete element })
        @buffered_set.delete element
        self
      end #delete
      
      def link_to_all(workspaces)
        each { |memberships| memberships.add workspace }
      end

      def unlink_from_all(workspace)
        each { |memberships| memberships.delete workspace }
      end #unlink_from_all

      def each
        fetch unless fetched?
        @current_backend.each do |key| 
          yield Membership::Collection.new(deserialize key)
        end
      end #each

      def size
        @current_backend.size
      end #size

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

      private

      def storage_key
        "entities:#{@entity_id}:workspaces:#{@workspace_id}:tracker"
      end
    end # Tracker
  end # Workspace
end # Belinkr

