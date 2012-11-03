# encoding: utf-8
require_relative '../../Tinto/Exceptions'
require_relative '../../Tinto/Context'

module Belinkr
  class EditScrapbook
    include Tinto::Exceptions
    include Tinto::Context

    def initialize(arguments)
      @actor              = arguments.fetch(:actor)
      @scrapbook          = arguments.fetch(:scrapbook)
      @scrapbook_changes  = arguments.fetch(:scrapbook_changes)
    end #initialize

    def call
      scrapbook.authorize(actor, 'update')
      scrapbook.update(scrapbook_changes)

      will_sync scrapbook
    end # call

    private

    attr_reader :actor, :scrapbook, :scrapbook_changes
  end # EditScrapbook
end # Belinkr

