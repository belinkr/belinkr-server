# encoding: utf-8
require_relative '../../Tinto/Exceptions'
require_relative '../../Tinto/Context'

module Belinkr
  class RemoveProfileFromEntity
    include Tinto::Context
    # Preconditions:
    # - An entity must be present
    # - A user in that entity must be present
    # - The user has a profile in that entity
    # - The user may have other profiles in other entities

    def initialize(actor, user, profile, profiles, entity)
      @actor    = actor
      @user     = user
      @entity   = entity
      @profile  = profile
      @profiles = profiles
    end # initialize

    def call
      raise Tinto::Exceptions::NotAllowed unless @actor.id == @user.id
      @user.profiles.delete @profile
      @user.delete if @user.profiles.empty?

      @profile.delete
      @profiles.delete @profile

      @to_sync = [@user, @profile, @profiles]
      @profile
    end # call
  end # RemoveProfileFromEntity
end # Belinkr

