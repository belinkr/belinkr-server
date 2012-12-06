# encoding: utf-8
require 'forwardable'
require_relative './Searcher/MemoryBackend'
require_relative './Searcher/ESBackend'

module Belinkr
  module User
    class Searcher
      extend Forwardable
      def_delegators :@backend, *MemoryBackend::INTERFACE 
      attr_reader :backend

      def initialize(backend=ESBackend.new)
        @backend     = backend
        # TODO: add more backends like Redis and ES
        #@persisted_set    = RedisBackend.new(storage_key)
        #@backend  = @persisted_set
        @backlog          = []
      end #initialize

      def autocomplete(chars)
        @backend.autocomplete(chars)
      end

    end # Searcher
  end # User
end # Belinkr

