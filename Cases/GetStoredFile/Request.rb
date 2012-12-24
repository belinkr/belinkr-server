# encoding: utf-8
require_relative '../../Config'
require_relative '../../Resources/StoredFile/Member'

module Belinkr
  module GetStoredFile
    class Request
      def initialize(arguments)
        @payload  = arguments.fetch(:payload)
        @actor    = arguments.fetch(:actor)
      end #initialize

      def prepare
        {
          stored_file_path: stored_file_path,
          http_options:     http_options
        }
      end #prepare

      private

      attr_reader :payload, :actor

      def stored_file
        @stored_file ||= 
          StoredFile::Member.new(id: payload.fetch('stored_file_id')).fetch
      end #stored_file

      def stored_file_path
        "#{Config::STORAGE_ROOT}/#{stored_file.path}"
      end #stored_file_path

      def http_options
        http_options = { 
          type:         stored_file.mime_type,
          filename:     stored_file.original_filename,
          disposition:  'inline'
        }

        http_options.delete(:disposition) unless payload['inline']
        http_options.delete(:filename)    if payload['inline']

        http_options
      end #http_options
    end # Request
  end # GetStoredFile
end # Belinkr

