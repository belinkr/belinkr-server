# encoding: utf-8
require_relative '../../Tinto/Exceptions'
require_relative '../../Tinto/Context'

module Belinkr
  class EditUserProfile
    include Tinto::Exceptions
    include Tinto::Context

    def initialize(actor, user, user_changes, profile, profile_changes)
      @actor            = actor
      @user             = user
      @user_changes     = user_changes#.sanitize
      @profile          = profile
      @profile_changes  = profile_changes#.sanitize
    end #initialize

    def call
      raise NotAllowed unless @actor.id == @user.id
      @user.update(@user_changes)

      @user.profiles.delete @profile
      @profile.update(@profile_changes)
      @user.profiles.push @profile

      @user.verify
      @profile.verify

      @to_sync = [@user, @profile]
      @profile
    end # call
  end
end # Belinkr

