# encoding: utf-8
require_relative '../Reset/Collection'
require_relative '../../Tinto/Context'

module Belinkr
  class ResetPassword
    include Tinto::Context

    def initialize(actor, user_changes, reset, resets=Reset::Collection.new)
      @actor        = actor
      @user_changes = user_changes
      @reset        = reset
      @resets       = resets
    end #initialize

    def call
      @actor.update(@user_changes)
      @actor.verify
      @reset.delete
      @resets.delete @reset

      @to_sync = [@actor, @reset, @resets]
      @reset
    end #call
  end # ResetPassword
end # Belinkr

