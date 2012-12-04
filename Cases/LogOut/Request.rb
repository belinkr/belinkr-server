# encoding: utf-8
require_relative '../../Resources/Session/Member'
require_relative '../../Resources/Session/Collection'

module Belinkr
  module LogOut
    class Request
      def initialize(payload)
        @payload  = payload
      end #initialize

      def prepare
        { 
          session:    Session::Member.new(payload).fetch,
          sessions:   Session::Collection.new
        }
      end #prepare

      private
      
      attr_reader :payload
    end # Request
  end # LogOut
end # Belinkr

