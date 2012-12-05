# encoding: utf-8
require 'forwardable'
require_relative './Searcher/MemoryBackend'

module Belinkr
  module User
    class Searcher
      extend Forwardable
      def_delegators :@current_backend, *MemoryBackend::INTERFACE 

      def initialize(options={})
        @buffered_hash     = options.fetch(:buffer, MemoryBackend.new)
        # TODO: add more backends like Redis and ES
        #@persisted_set    = RedisBackend.new(storage_key)
        #@current_backend  = @persisted_set
        @current_backend  = @buffered_hash
        @backlog          = []
      end #initialize

      def autocomplete(chars)
        @current_backend.autocomplete(chars)
      end

    end # Searcher
  end # User
end # Belinkr

