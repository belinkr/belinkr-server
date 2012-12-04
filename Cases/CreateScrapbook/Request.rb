# encoding: utf-8
require_relative '../../Resources/Scrapbook/Member'
require_relative '../../Resources/Scrapbook/Collection'

module Belinkr
  module CreateScrapbook
    class Request
      def initialize(payload, actor)
        @payload  = payload
        @actor    = actor
      end #initialize

      def prepare
        {
          actor:      actor,
          scrapbook:  scrapbook,
          scrapbooks: scrapbooks,
        }
      end # prepare

      private 
      
      attr_accessor :payload, :actor

      def scrapbook
        Scrapbook::Member.new(payload)
      end #scrapbook

      def scrapbooks
        Scrapbook::Collection.new(user_id: actor.id)
      end #scrapbooks
    end # Request
  end # CreateScrapbook
end # Belinkr

