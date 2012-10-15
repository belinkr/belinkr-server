# encoding: utf-8
require_relative '../Reset/Collection'

module Belinkr
  class ResetPassword
    def initialize(actor, reset, user_changes)
      @actor        = actor
      @reset        = reset
      @user_changes = user_changes
      @resets       = Reset::Collection.new
    end

    def call
      $redis.multi do
        @actor.update(@user_changes)
        @reset.delete
        @resets.remove @reset
      end
      @reset
    end
  end # ResetPassword
end # Belinkr
