# encoding: utf-8
require 'json'
require 'Tinto/Presenter'

module Belinkr
  module Status
    class Presenter
      def initialize(status, actor=nil)
        @status = status
        @actor  = actor
      end

      def as_json
        as_poro.to_json
      end

      def as_poro
        {
          id:         status.id,
          text:       status.text,
        }
         .merge! Tinto::Presenter.timestamps_for(status)
         .merge! Tinto::Presenter.errors_for(status)
         .merge! files
      end #as_poro

      private

      attr_reader :status, :actor

      def files
        { files: @status.files }
      end
    end # Presenter
  end # Status
end # Belinkr
