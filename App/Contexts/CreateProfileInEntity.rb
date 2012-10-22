# encoding: utf-8
require_relative '../Profile/Collection'
require_relative '../User/Locator'
require_relative '../../Tinto/Exceptions'
require_relative '../../Tinto/Context'

module Belinkr
  class CreateProfileInEntity
    include Tinto::Context
    # Preconditions: an entity must be created
    #
    def initialize(actor, profile, profiles, entity)
      @actor    = actor
      @profile  = profile
      @profiles = profiles
      @entity   = entity
    end # initialize

    def call
      unless User::Locator.registered?(@actor.id)
        User::Locator.add(@actor.email, @actor.id) 
      end

      @actor.verify

      @profile.user_id    = @actor.id
      @profile.entity_id  = @entity.id
      @profile.verify

      @actor.profiles.push @profile
      @actor.verify

      @profiles.add @profile

      @to_sync = [@actor, @profile, @profiles]
      @profile
    end # call
  end # CreateProfileInEntity
end # Belinkr

