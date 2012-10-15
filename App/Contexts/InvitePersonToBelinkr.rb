# encoding: utf-8
require 'i18n'
require_relative '../../Locales/Loader'
require_relative '../../Config'
require_relative '../Invitation/Collection'
require_relative '../Entity/Member'
require_relative '../Activity/Collection'
require_relative '../Activity/Member'
require_relative '../../Workers/Mailer/Message'

module Belinkr
  class InvitePersonToBelinkr
    BASE_PATH = "https://#{Belinkr::Config::HOSTNAME}/invitations"

    def initialize(actor, invitation, entity)
      @actor        = actor
      @invitation   = invitation
      @entity       = entity
      @activities   = Activity::Collection.new(entity_id: entity.id)
      @invitations  = Invitation::Collection.new(entity_id: entity.id)
    end

    def call
      @invitation.inviter_id  = @actor.id
      @invitation.entity_id   = @entity.id

      message = message_for(@actor, @invitation, @entity)
      @invitation.save

      activity = Activity::Member.new(
        actor:      @actor, 
        action:     'invite', 
        # Since invited person doesn't have User::Member yet,
        # we use the invited_name
        object:     @invitation.invited_name,
        entity_id:  @entity.id
      ).save

      $redis.multi do
        @invitations.add @invitation
        @activities.add activity
        Mailer::Message.new(message).queue
      end
      
      @invitation
    end

    private

    def message_for(actor, invitation, entity)
      {
        from:           "#{actor.name} via belinkr <help@belinkr.com>",
        to:             invitation.invited_name +
                          " <#{invitation.invited_email}>",
        subject:        I18n::t('mailer.invitation.subject', 
                          inviter_name: actor.name),
        template:       "invitation",
        locale:         invitation.locale,
        substitutions:  {
          inviter_name:     actor.name,
          invited_name:     invitation.invited_name,
          entity_name:      entity.name,
          invitation_link:  "#{BASE_PATH}/#{@invitation.id}"
        }
      }
    end
  end # InvitePersonToBelinkr
end # Belinkr

