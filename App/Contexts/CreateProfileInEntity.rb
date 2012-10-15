# encoding: utf-8
require_relative '../Profile/Collection'
require_relative '../User/Locator'
require_relative '../../Tinto/Exceptions'

module Belinkr
  class CreateProfileInEntity
    # Preconditions: an entity must be created and persisted
    #
    def initialize(actor, profile, entity)
      @actor     = actor
      @entity   = entity
      @profile  = profile
      @profiles = Profile::Collection.new(entity_id: @entity.id)
    end # initialize

    def call
      unless User::Locator.registered?(@actor.id)
        @actor.save
        User::Locator.add(@actor.email, @actor.id) 
      end

      @profile.user_id    = @actor.id
      @profile.entity_id  = @entity.id
      @profile.save

      @actor.profile_ids.push(@profile.id)
      @actor.entity_ids.push(@entity.id)

      $redis.multi do
        @actor.save
        @profiles.add @profile
      end

      @profile
    rescue Tinto::Exceptions::InvalidResource => exception
      if @profile.id 
        @actor.profile_ids.delete(@profile.id)
        @actor.entity_ids.delete(@entity.id)
        @profiles.remove @profile             
        @profile.destroy                     
      end

      @actor.destroy if @actor.profile_ids.empty? && @actor.entity_ids.empty?

      raise exception
    end # call
  end # CreateProfileInEntity
end # Belinkr

