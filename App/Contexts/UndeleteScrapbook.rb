# encoding: utf-8
require_relative '../../Tinto/Context'

module Belinkr
  class UndeleteScrapbook
    include Tinto::Context

    def initialize(arguments)
      @actor      = arguments.fetch(:actor)
      @scrapbook  = arguments.fetch(:scrapbook)
      @scrapbooks = arguments.fetch(:scrapbooks)
    end #initialize

    def call
      scrapbook.authorize(actor, :undelete)
      scrapbook.undelete
      scrapbooks.add(scrapbook)

      will_sync scrapbook, scrapbooks
    end #call

    private

    attr_reader :actor, :scrapbook, :scrapbooks
  end # UndeleteScrapbook
end # Belinkr

