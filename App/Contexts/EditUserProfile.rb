# encoding: utf-8
require_relative '../../Tinto/Exceptions'
require_relative '../../Tinto/Context'

module Belinkr
  class EditUserProfile
    include Tinto::Exceptions
    include Tinto::Context

    attr_reader :actor, :user, :profile, :user_changes, :profile_changes

    def initialize(arguments)
      @actor            = arguments.fetch(:actor)
      @user             = arguments.fetch(:user)
      @user_changes     = arguments.fetch(:user_changes)
      @profile          = arguments.fetch(:profile)
      @profile_changes  = arguments.fetch(:profile_changes)
    end #initialize

    def call
      raise NotAllowed unless actor.id == user.id
      user.update(user_changes)

      user.unlink_from(profile)
      profile.update(profile_changes)
      user.link_to(profile)

      user.validate!
      profile.validate!
      will_sync user, profile
    end # call
  end # EditUserProfile
end # Belinkr

