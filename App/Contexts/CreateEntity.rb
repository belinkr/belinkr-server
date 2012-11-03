# encoding: utf-8
require_relative '../../Tinto/Context'

module Belinkr
  class CreateEntity
    include Tinto::Context
    
    def initialize(arguments)
      @entity   = arguments.fetch(:entity)
      @entities = arguments.fetch(:entities)
    end # initialize

    def call
      entities.add entity
      will_sync entity, entities
    end # call

    private

    attr_reader :entity, :entities
  end # CreateEntity
end # Belinkr

