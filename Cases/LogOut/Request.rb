# encoding: utf-8
require_relative '../../Resources/Session/Collection'

module Belinkr
  module LogOut
    class Request
      def initialize(session)
        @session  = session
      end #initialize

      def prepare
        { 
          session:    session,
          sessions:   Session::Collection.new
        }
      end #prepare

      private
      
      attr_reader :session
    end # Request
  end # LogOut
end # Belinkr

