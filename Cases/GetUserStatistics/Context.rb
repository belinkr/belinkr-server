# encoding: utf-8
require 'Tinto/Context'
module Belinkr
  module GetUserStatistics
    class Context
      include Tinto::Context

      def initialize(arguments)
        @enforcer           = arguments.fetch(:enforcer)

        @actor              = arguments.fetch(:actor)
        @user               = arguments.fetch(:user)
      end #initialize

      def call
        enforcer.authorize(actor, :get_user_statistics)
      end #call

      private

      attr_reader :enforcer, :actor, :user
    end # Context
  end # GetStatus
end # Belinkr

