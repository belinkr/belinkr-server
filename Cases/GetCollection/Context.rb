#encoding: utf-8
require 'Tinto/Context'

module Belinkr
  module GetCollection
    class Context
      include Tinto::Context

      def initialize(arguments)
        @actor      = arguments.fetch(:actor)
        @collection = arguments.fetch(:collection)
        @enforcer   = arguments.fetch(:enforcer)
      end

      def call
        enforcer.authorize(actor, :collection)
      end #call

      private

      attr_reader :actor, :collection, :enforcer
    end # Context
  end # GetCollection
end # Belinkr

