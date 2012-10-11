# encoding: utf-8
require_relative '../Profile/Collection'
require_relative '../../Tinto/Exceptions'

class RemoveProfileFromEntity
  # Preconditions:
  # - An entity must be persited
  # - A user in that entity must be persisted
  # - The user has a profile in that entity
  # - The user may have other profiles in other entities

  def initialize(actor, user, profile, entity)
    @actor    = actor
    @user     = user
    @entity   = entity
    @profile  = profile
    @profiles = Profile::Collection.new(entity_id: @entity.id)
  end # initialize

  def call
    raise Tinto::Exceptions::NotAllowed unless @actor.id == @user.id
    @user.profile_ids.delete(@profile.id)
    @user.entity_ids.delete(@entity.id)

    $redis.multi do
      no_more_profiles? ? @user.delete : @user.save
      @profile.delete
      @profiles.remove @profile
    end
    @profile
  end # call

  private

  def no_more_profiles?
    @user.profile_ids.empty? && @user.entity_ids.empty?
  end
end # RemoveProfileFromEntity

