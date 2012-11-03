# encoding: utf-8
require_relative '../Reset/Collection'
require_relative '../../Tinto/Context'

module Belinkr
  class ResetPassword
    include Tinto::Context

    attr_reader :actor, :user_changes, :reset, :resets

    def initialize(arguments)
      @actor        = arguments.fetch(:actor)
      @user_changes = arguments.fetch(:user_changes)
      @reset        = arguments.fetch(:reset)
      @resets       = arguments.fetch(:resets) || Reset::Collection.new
    end #initialize

    def call
      actor.update(user_changes)
      reset.delete
      resets.delete reset

      will_sync actor, reset, resets
    end #call
  end # ResetPassword
end # Belinkr

