# encoding: utf-8
require 'Tinto/Context'

module Belinkr
  module CreateScrapbook
    class Context
      include Tinto::Context

      def initialize(arguments)
        @actor      = arguments.fetch(:actor)
        @scrapbook  = arguments.fetch(:scrapbook)
        @scrapbooks = arguments.fetch(:scrapbooks)
      end

      def call
        scrapbook.link_to(actor)
        scrapbooks.add scrapbook

        will_sync scrapbook, scrapbooks
      end #call

      private

      attr_reader :actor, :scrapbook, :scrapbooks
    end # Context
  end # CreateScrapbook
end # Belinkr

