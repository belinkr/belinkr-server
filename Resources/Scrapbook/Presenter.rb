# encoding: utf-8
require 'json'
require 'Tinto/Presenter'

module Belinkr
  module Scrapbook
    class Presenter
      BASE_PATH = '/scrapbooks'

      def initialize(scrapbook, actor)
        @scrapbook  = scrapbook
        @actor      = actor
      end #initialize

      def as_poro
        {
          id:    scrapbook.id,
          name:  scrapbook.name,
        }
          .merge! Tinto::Presenter.timestamps_for(scrapbook)
          .merge! Tinto::Presenter.errors_for(scrapbook)
          .merge! links
      end #as_poro

      def as_json
        as_poro.to_json
      end #as_json
     
      private

      attr_reader :scrapbook, :actor

      def links
        {
          _links: {
            self:   "#{BASE_PATH}/#{scrapbook.id}",
            user:   "/users/#{actor.id}",
            scraps: "#{BASE_PATH}/#{scrapbook.id}/scraps"
          }
        }
      end #links
    end # Presenter
  end # Scrapbook
end #Belinkr

