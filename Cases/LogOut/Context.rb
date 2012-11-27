# encoding: utf-8
require 'Tinto/Context'

module Belinkr
  module LogOut
    class Context
      include Tinto::Context

      def initialize(arguments)
        @session  = arguments.fetch(:session)
        @sessions = arguments.fetch(:sessions)
      end # initialize

      def call
        sessions.delete session
        session.expire

        will_sync sessions
      end # call
      
      private

      attr_reader :session, :sessions
    end # Context
  end # LogOut
end # Belinkr

