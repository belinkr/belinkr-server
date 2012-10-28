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
    def initialize(actor, profile, profiles, entity, 
    user_locator=User::Locator.new)
      @actor        = actor
      @profile      = profile
      @profiles     = profiles
      @entity       = entity
      @user_locator = user_locator
    end # initialize

    def call
      @actor.verify
      @user_locator.add(@actor.email, @actor.id) 

      @profile.user_id    = @actor.id
      @profile.entity_id  = @entity.id
      @profile.verify

      @actor.profiles.push @profile
      @actor.verify

      @profiles.add @profile

      @to_sync = [@actor, @profile, @profiles, @user_locator]
      @profile
    end # call
  end # CreateProfileInEntity
end # Belinkr

