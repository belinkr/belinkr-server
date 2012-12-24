# encoding: utf-8
require 'Tinto/Context'

module Belinkr
  module StoreFile
    class Context
      include Tinto::Context

      def initialize(arguments)
        @stored_file = arguments.fetch(:stored_file)
      end #initialize

      def call
        will_sync stored_file
      end #call

      private

      attr_reader :stored_file
    end # Context
  end # Storefile
end # Belinkr

