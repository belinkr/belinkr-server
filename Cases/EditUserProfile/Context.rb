# encoding: utf-8
require 'Tinto/Context'

module Belinkr
  module EditUserProfile
    class Context
      include Tinto::Context

      def initialize(arguments)
        @enforcer         = arguments.fetch(:enforcer)
        @actor            = arguments.fetch(:actor)
        @user             = arguments.fetch(:user)
        @user_changes     = arguments.fetch(:user_changes)
        @profile          = arguments.fetch(:profile)
        @profile_changes  = arguments.fetch(:profile_changes)
      end #initialize

      def call
        enforcer.authorize(actor, :update)
        user.update_details(
          profile:          profile, 
          user_changes:     user_changes,
          profile_changes:  profile_changes
        )

        will_sync user, profile
      end # call

      private

      attr_reader :enforcer, :actor, :user, :profile, :user_changes, 
                  :profile_changes
    end # Context
  end # EditUserProfile
end # Belinkr

