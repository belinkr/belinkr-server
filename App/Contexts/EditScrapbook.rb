# encoding: utf-8
require_relative '../../Tinto/Exceptions'
require_relative '../../Tinto/Context'

module Belinkr
  class EditScrapbook
    include Tinto::Exceptions
    include Tinto::Context

    def initialize(actor, scrapbook, scrapbook_changes)
      @actor              = actor
      @scrapbook          = scrapbook
      @scrapbook_changes  = scrapbook_changes
    end #initialize

    def call
      raise NotAllowed unless @actor.id == @scrapbook.user_id
      @scrapbook.update(@scrapbook_changes)
      @scrapbook.verify

      @to_sync = [@scrapbook]
      @scrapbook
    end # call
  end # EditScrapbook
end # Belinkr

