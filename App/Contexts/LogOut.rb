# encoding: utf-8
require_relative '../Session/Collection'
require_relative '../../Tinto/Context'

module Belinkr
  class LogOut
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
  end # LogOut
end # Belinkr

