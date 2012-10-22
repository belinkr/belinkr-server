# encoding: utf-8
require_relative '../Session/Collection'
require_relative '../../Tinto/Context'

module Belinkr
  class LogOut
    include Tinto::Context

    def initialize(session, sessions=Session::Collection.new)
      @session  = session
      @sessions = sessions
    end # initialize

    def call
      @sessions.delete @session
      @session.delete
      @session.destroy

      @to_sync = [@sessions]
      @session
    end # call
  end # LogOut
end # Belinkr

