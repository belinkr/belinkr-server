# encoding: utf-8
require_relative '../../Tinto/Exceptions'
require_relative '../../Tinto/Context'

module Belinkr
  class RemoveProfileFromEntity
    include Tinto::Context
    include Tinto::Exceptions

    attr_reader :actor, :user, :entity, :profile, :profiles

    def initialize(arguments)
      @actor    = arguments.fetch(:actor)
      @user     = arguments.fetch(:user)
      @entity   = arguments.fetch(:entity)
      @profile  = arguments.fetch(:profile)
      @profiles = arguments.fetch(:profiles)
    end # initialize

    def call
      raise NotAllowed unless actor.id == user.id
      user.profiles.delete profile
      user.delete if user.profiles.empty?

      profile.delete
      profiles.delete profile

      will_sync user, profile, profiles
    end # call
  end # RemoveProfileFromEntity
end # Belinkr

