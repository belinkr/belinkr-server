# encoding: utf-8
require_relative './Locator/MemoryBackend'
require_relative './Locator/RedisBackend'

module Belinkr
  module User
    class Locator
      def initialize(options={})
        @buffer           = options.fetch(:buffer, MemoryBackend.new)
        @persisted        = options.fetch(:backend, RedisBackend.new)
        @backlog          = []
        @current_backend  = @persisted
      end #initialize

      def add(*args)
        @buffer.add *args
        @backlog.push(lambda { @persisted.add *args })
      end #add

      def delete(*args)
        @buffer.delete *args
        @backlog.push(lambda { @persisted.delete *args })
      end #delete

      def id_for(*args)
        @current_backend.id_for *args
      end #id_for

      def keys_for(*args)
        @current_backend.keys_for *args
      end #keys_for

      def registered?(*args)
        @current_backend.registered? *args
      end #registered?

      def synced?
        @backlog.empty?
      end #synced?

      def sync
        @backlog.each { |command| command.call }
        @backlog.clear
        self
      end #sync

      def fetched?
        @current_backend.eql? @buffer
      end #fetched?

      def fetch
        @persisted.fetch.each { |key, value| @buffer.add key, value }
        @current_backend = @buffer
        self
      end #fetch

      def reset(records=[])
        records.each { |key, value| add key, value }
        @current_backend = @buffer
        self
      end #reset
    end # Locator
  end # User
end # Belinkr

