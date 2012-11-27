# encoding: utf-8
require 'bcrypt'
require 'Tinto/Context'

module Belinkr
  module LogIn
    class Context
      include Tinto::Context

      def initialize(arguments)
        @actor      = arguments.fetch(:actor)
        @plaintext  = arguments.fetch(:plaintext)
        @session    = arguments.fetch(:session)
        @sessions   = arguments.fetch(:sessions)
      end # initialize

      def call
        actor.authenticate(session, plaintext)
        sessions.add session

        will_sync session, sessions
      end # call

      private

      attr_reader :actor, :plaintext, :session, :sessions
    end # Context
  end # LogIn
end # Belinkr

