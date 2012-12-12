# encoding: utf-8
require 'json'

module Belinkr
  module StoredFile
    class Presenter
      BASE_PATH = "/files"

      def initialize(stored_file, actor=nil)
        @stored_file  = stored_file
        @actor        = actor
      end #initialize

      def as_json
        as_poro.to_json
      end #as_json

      def as_poro
        {
          id:                 stored_file.id, 
          mime_type:          stored_file.mime_type, 
          original_filename:  stored_file.original_filename 
        }.merge! Tinto::Presenter.timestamps_for(stored_file)
         .merge! Tinto::Presenter.errors_for(stored_file)
         .merge! links
      end #as_poro

      private

      attr_accessor :stored_file, :actor

      def links
        {
          links: {
            self:  "#{BASE_PATH}/#{stored_file.id}"
          }.merge!(thumbnail_links)
        }
      end #links

      def thumbnail_links
        return {} unless stored_file.image?
        return {
          mini:   "#{BASE_PATH}/#{stored_file.id}?version=mini&inline=true",
          small:  "#{BASE_PATH}/#{stored_file.id}?version=small&inline=true"
        }
      end #thumbnail_links
    end # Presenter
  end # Status
end # Belinkr

