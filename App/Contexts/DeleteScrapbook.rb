# encoding: utf-8
require_relative '../../Tinto/Context'
require_relative '../../Tinto/Exceptions'

module Belinkr
  class DeleteScrapbook
    include Tinto::Context
    include Tinto::Exceptions

    def initialize(arguments)
      @actor      = arguments.fetch(:actor)
      @scrapbook  = arguments.fetch(:scrapbook)
      @scrapbooks = arguments.fetch(:scrapbooks)
    end # initialize

    def call
      scrapbook.authorize(actor, 'delete')
      scrapbook.delete
      scrapbooks.delete scrapbook

      will_sync scrapbook, scrapbooks
    end # call

    private

    attr_reader :actor, :scrapbook, :scrapbooks
  end # DeleteScrapbook
end # Belinkr

