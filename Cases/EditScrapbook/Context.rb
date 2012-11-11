# encoding: utf-8
require_relative '../../Tinto/Context'

module Belinkr
  module EditScrapbook
    class Context
      include Tinto::Context

      def initialize(arguments)
        @enforcer           = arguments.fetch(:enforcer)
        @actor              = arguments.fetch(:actor)
        @scrapbook          = arguments.fetch(:scrapbook)
        @scrapbook_changes  = arguments.fetch(:scrapbook_changes)
      end #initialize

      def call
        enforcer.authorize(actor, :update)
        scrapbook.update(scrapbook_changes)

        will_sync scrapbook
      end # call

      private

      attr_reader :enforcer, :actor, :scrapbook, :scrapbook_changes
    end # Context
  end # EditScrapbook
end # Belinkr

