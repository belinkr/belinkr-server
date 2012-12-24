# encoding: utf-8
require_relative '../../Resources/Scrapbook/Member'
require_relative '../../Resources/Scrapbook/Collection'
require_relative '../../Resources/Scrapbook/Enforcer'

module Belinkr
  module DeleteScrapbook
    class Request
      def initialize(arguments)
        @payload  = arguments.fetch(:payload)
        @actor    = arguments.fetch(:actor)
      end #initialize

      def prepare
        {
          actor:      actor,
          enforcer:   enforcer,
          scrapbook:  scrapbook,
          scrapbooks: scrapbooks,
        }
      end # prepare

      private
      
      attr_reader :payload, :actor

      def scrapbook
        @scrapbook ||= Scrapbook::Member.new(
          id:       payload.fetch('scrapbook_id'),
          user_id:  actor.id
        ).fetch
      end #scrapbook

      def scrapbooks
        Scrapbook::Collection.new(user_id: actor.id, kind: 'own')
      end #scrapbooks

      def enforcer
        Scrapbook::Enforcer.new(scrapbook)
      end #enforcer
    end # Request
  end # DeleteScrapbook
end # Belinkr

