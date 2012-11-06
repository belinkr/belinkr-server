# encoding: utf-8
require_relative '../../Tinto/Context'

module Belinkr
  class RemoveProfileFromEntity
    include Tinto::Context

    def initialize(arguments)
      @enforcer = arguments.fetch(:enforcer)
      @actor    = arguments.fetch(:actor)
      @user     = arguments.fetch(:user)
      @profile  = arguments.fetch(:profile)
      @profiles = arguments.fetch(:profiles)
    end # initialize

    def call
      enforcer.authorize(actor, :delete)
      user.unlink_from(profile)

      profile.delete
      profiles.delete profile

      will_sync user, profile, profiles
    end # call

    private

    attr_reader :enforcer, :actor, :user, :profile, :profiles
  end # RemoveProfileFromEntity
end # Belinkr

