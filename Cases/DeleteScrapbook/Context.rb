# encoding: utf-8
require_relative '../../Tinto/Context'

module Belinkr
  module DeleteScrapbook
    class Context
      include Tinto::Context

      def initialize(arguments)
        @enforcer   = arguments.fetch(:enforcer)
        @actor      = arguments.fetch(:actor)
        @scrapbook  = arguments.fetch(:scrapbook)
        @scrapbooks = arguments.fetch(:scrapbooks)
      end # initialize

      def call
        enforcer.authorize(actor, 'delete')
        scrapbook.delete
        scrapbooks.delete scrapbook

        will_sync scrapbook, scrapbooks
      end # call

      private

      attr_reader :enforcer, :actor, :scrapbook, :scrapbooks
    end # Context
  end # DeleteScrapbook
end # Belinkr

