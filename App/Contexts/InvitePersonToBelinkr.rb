# encoding: utf-8
require 'i18n'
require_relative '../../Locales/Loader'
require_relative '../../Config'
require_relative './RegisterActivity'
require_relative '../../Tinto/Context'
require_relative '../../Tinto/Exceptions'

module Belinkr
  class InvitePersonToBelinkr
    include Tinto::Context
    include Tinto::Exceptions

    BASE_PATH = "https://#{Belinkr::Config::HOSTNAME}/invitations"

    def initialize(actor, invitation, invitations, entity, message)
      @actor        = actor
      @invitation   = invitation
      @invitations  = invitations
      @entity       = entity
      @message      = message
    end # initialize

    def call
      @invitation.inviter_id  = @actor.id
      @invitation.entity_id   = @entity.id

      @invitation.verify
      @invitations.add @invitation

      @message.attributes = message_for(@actor, @invitation, @entity)
      raise InvalidResource unless @message.valid?

      @activity_context = RegisterActivity.new(
        actor:      @actor, 
        action:     'invite', 
        # Since invited person doesn't have User::Member yet,
        # we use the invited_name
        object:     @invitation.invited_name,
        entity_id:  @entity.id
      )
      @activity_context.call

      @to_sync = [@invitation, @invitations, @activity_context, @message]
      @invitation
    end #call

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

