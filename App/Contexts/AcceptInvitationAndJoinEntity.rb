# encoding: utf-8
require_relative '../Contexts/CreateProfileInEntity'
require_relative '../Profile/Member'
require_relative '../Activity/Member'
require_relative '../Activity/Collection'

class AcceptInvitationAndJoinEntity
  def initialize(actor, invitation, entity)
    @actor      = actor
    @invitation = invitation
    @entity     = entity
    @profile    = Profile::Member.new(user_id: @actor.id, entity_id: @entity.id)
    @activities = Activity::Collection.new(entity_id: @entity.id)
  end

  def call
    @actor.save
    @invitation.accept
    CreateProfileInEntity.new(@actor, @profile, @entity).call
    
    activity = Activity::Member.new(
      actor:      @actor, 
      action:     'accept',
      object:     @invitation,
      entity_id:  @entity.id
    ).save

    $redis.multi do
      @invitation.save
      @activities.add activity
    end

    @invitation
  end
end

