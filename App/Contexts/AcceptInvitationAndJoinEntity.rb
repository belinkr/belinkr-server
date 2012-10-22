# encoding: utf-8
require_relative './CreateProfileInEntity'
require_relative './RegisterActivity'
require_relative '../Profile/Member'
require_relative '../Profile/Collection'

module Belinkr
  class AcceptInvitationAndJoinEntity
    def initialize(actor, invitation, entity, profile=Profile::Member.new)
      @actor      = actor
      @invitation = invitation
      @entity     = entity
      @profile    = profile
      @profiles   = Profile::Collection.new(entity_id: @entity.id)
    end #initialize

    def call
      @profile.id         = @actor.id
      @profile.entity_id  = @entity.id
      @invitation.accept

      @profile_context    = CreateProfileInEntity
                              .new(@actor, @profile, @profiles, @entity).call
      @activity_context   = RegisterActivity.new(
                              actor:      @actor, 
                              action:     'accept',
                              object:     @invitation,
                              entity_id:  @entity.id
                            ).call

      @to_sync = [@invitation, @profile_context, @activity_context]
      @invitation
    end #call
  end
end # Belinkr

