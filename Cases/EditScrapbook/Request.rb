# encoding: utf-8
require_relative '../../Resources/Scrapbook/Member'
require_relative '../../Resources/Scrapbook/Enforcer'

module Belinkr
  module EditScrapbook
    class Request
      def initialize(arguments)
        @payload  = arguments.fetch(:payload)
        @actor    = arguments.fetch(:actor)
      end #initialize

      def prepare
        {
          actor:              actor,
          enforcer:           enforcer,
          scrapbook:          scrapbook,
          scrapbook_changes:  payload
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

      def enforcer
        Scrapbook::Enforcer.new(scrapbook)
      end #enforcer
    end # Request
  end # EditScrapbook
end # Belinkr

