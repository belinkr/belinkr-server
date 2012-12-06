# encoding: utf-8
require 'forwardable'
require_relative './Searcher/MemoryBackend'
require_relative './Searcher/ESBackend'

module Belinkr
  class Searcher
    extend Forwardable
    def_delegators :@backend, *MemoryBackend::INTERFACE 
    attr_reader :backend

    def initialize(backend)
      @backend     = backend
      # TODO: add more backends like Redis and ES
      #@persisted_set    = RedisBackend.new(storage_key)
      #@backend  = @persisted_set
      @backlog          = []
    end #initialize

    def autocomplete(index, chars)
      @backend.autocomplete(index, chars)
    end

  end # Searcher
end # Belinkr

