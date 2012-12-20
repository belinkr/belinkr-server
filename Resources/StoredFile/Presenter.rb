# encoding: utf-8
require 'json'

module Belinkr
  module StoredFile
    class Presenter
      def initialize(stored_file, scope={})
        @stored_file  = stored_file
      end #initialize

      def as_json(*args)
        as_poro.to_json(*args)
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

      attr_accessor :stored_file

      def links
        {
          _links: { self:  "/files/#{stored_file.id}" }.merge!(thumbnail_links)
        }
      end #links

      def thumbnail_links
        return {} unless stored_file.image?
        return {
          mini:   "#/files/#{stored_file.id}?version=mini&inline=true",
          small:  "#/files/#{stored_file.id}?version=small&inline=true"
        }
      end #thumbnail_links
    end # Presenter
  end # Status
end # Belinkr

