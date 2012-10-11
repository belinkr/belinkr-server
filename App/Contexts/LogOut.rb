# encoding: utf-8
require_relative '../Session/Collection'

class LogOut
  def initialize(session)
    @session  = session
    @sessions = Session::Collection.new
  end # initialize

  def call
    $redis.multi do
      @sessions.remove @session
      @session.delete.destroy
    end
    @session
  end # call
end # LogOut

