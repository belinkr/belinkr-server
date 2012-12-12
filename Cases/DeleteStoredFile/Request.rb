# encoding: utf-8
require_relative '../../Resources/StoredFile/Member'

module Belinkr
  module DeleteStoredFile
    class Request
      def initialize(payload, actor)
        @payload  = payload
        @actor    = actor
      end #initialize

      def prepare
        { stored_file: stored_file }
      end #prepare

      private

      attr_reader :payload, :actor

      def stored_file
        @stored_file ||= 
          StoredFile::Member.new(id: payload.fetch('stored_file_id')).fetch
      end #stored_file
    end # Request
  end # DeleteStoredFile
end # Belinkr

