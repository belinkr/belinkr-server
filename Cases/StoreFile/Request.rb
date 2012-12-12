# encoding: utf-8
require_relative '../../Resources/StoredFile/Member'

module Belinkr
  module StoreFile
    class Request
      def initialize(payload, actor)
        @payload  = payload.fetch('file')
        @actor    = actor
      end #initialize

      def prepare
        { stored_file: stored_file }
      end #prepare

      private

      attr_reader :payload, :actor

      def stored_file
        @stored_file ||= StoredFile::Member.new(
          {
            mime_type:          payload.fetch(:type),
            original_filename:  payload.fetch(:filename)
          },
          payload.fetch(:tempfile)
        )
      end #stored_file
    end # Request
  end # StoreFile
end # Belinkr

