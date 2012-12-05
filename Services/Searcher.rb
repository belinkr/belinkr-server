# encoding: utf-8
require 'forwardable'
require_relative './Searcher/MemoryBackend'
require_relative './Searcher/ESBackend'

module Belinkr
  module User
    class Searcher
      extend Forwardable
      def_delegators :@backend, *MemoryBackend::INTERFACE 

      def initialize(backend=MemoryBackend.new)
        @backend     = backend
        # TODO: add more backends like Redis and ES
        #@persisted_set    = RedisBackend.new(storage_key)
        #@current_backend  = @persisted_set
        @backlog          = []
      end #initialize

      def autocomplete(chars)
        @backend.autocomplete(chars)
      end

    end # Searcher
  end # User
end # Belinkr

