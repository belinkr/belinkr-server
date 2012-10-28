# encoding: utf-8
require_relative '../Scrapbook/Collection'
require_relative '../../Tinto/Context'
require_relative '../../Tinto/Exceptions'

module Belinkr
  class UndeleteScrapbook
    include Tinto::Context
    include Tinto::Exceptions

    def initialize(actor, scrapbook, scrapbooks)
      @actor      = actor
      @scrapbook  = scrapbook
      @scrapbooks = scrapbooks
    end #initialize

    def call
      raise NotAllowed unless @actor.id == @scrapbook.user_id
      @scrapbook.undelete
      @scrapbooks.add @scrapbook

      @to_sync = [@scrapbook, @scrapbooks]
      @scrapbook
    end #call
  end # UndeleteScrapbook
end # Belinkr

