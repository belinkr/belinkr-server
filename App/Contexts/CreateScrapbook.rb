# encoding: utf-8
require_relative '../../Tinto/Context'

module Belinkr
  class CreateScrapbook
    include Tinto::Context

    def initialize(actor, scrapbook, scrapbooks)
      @actor          = actor
      @scrapbook      = scrapbook
      @scrapbooks     = scrapbooks
    end

    def call
      @scrapbook.user_id = @actor.id
      @scrapbook.verify
      @scrapbooks.add @scrapbook

      @to_sync = [@scrapbook, @scrapbooks]
      @scrapbook
    end #to_sync
  end # CreateScrapbook
end # Belinkr

