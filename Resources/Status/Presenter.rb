# encoding: utf-8
require 'json'
require 'Tinto/Presenter'

module Belinkr
  module Status
    class Presenter
      def initialize(status, scope={})
        @status = status
      end

      def as_json(*args)
        as_poro.to_json(*args)
      end

      def as_poro
        {
          id:         status.id,
          author:     status.author.to_clean_hash,
          text:       status.text,
          files:      status.files,
          url:        status.url,
          replies:    status.replies
        }
         .merge! Tinto::Presenter.timestamps_for(status)
         .merge! Tinto::Presenter.errors_for(status)
      end #as_poro

      private

      attr_reader :status
    end # Presenter
  end # Status
end # Belinkr

