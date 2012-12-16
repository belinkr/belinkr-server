# encoding: utf-8
require_relative '../../Resources/Scrapbook/Member'
require_relative '../../Resources/Scrapbook/Collection'

module Belinkr
  module CreateScrapbook
    class Request
      def initialize(arguments)
        @payload  = arguments.fetch(:payload)
        @actor    = arguments.fetch(:actor)
      end #initialize

      def prepare
        {
          actor:      actor,
          scrapbook:  scrapbook,
          scrapbooks: scrapbooks,
        }
      end # prepare

      private 
      
      attr_reader :payload, :actor

      def scrapbook
        Scrapbook::Member.new(payload.merge scope)
      end #scrapbook

      def scrapbooks
        Scrapbook::Collection.new(user_id: actor.id, kind: 'own')
      end #scrapbooks

      def scope
        { user_id: actor.id }
      end #scope
    end # Request
  end # CreateScrapbook
end # Belinkr

