# encoding: utf-8
require_relative '../../Tinto/Exceptions'

module Belinkr
  class EditUserProfile
    include Tinto

    def initialize(actor, user, user_changes, profile, profile_changes)
      @actor            = actor
      @user             = user
      @user_changes     = user_changes.sanitize
      @profile          = profile
      @profile_changes  = profile_changes.sanitize
    end

    def call
      raise Tinto::Exceptions::NotAllowed unless @actor.id == @user.id
      $redis.multi do
        @user.update(@user_changes)
        @profile.update(@profile_changes)
      end

      @profile
    end
  end
end # Belinkr

