# encoding: utf-8
require_relative '../../Tinto/Context'

module Belinkr
  class CreateScrapbook
    include Tinto::Context

    attr_reader :actor, :scrapbook, :scrapbooks

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
  end # CreateScrapbook
end # Belinkr

