# encoding: utf-8
require 'redis'
require 'json'
require 'virtus'
require 'aequitas'
require_relative '../../Config'
require_relative '../../Tinto/Exceptions'

module Belinkr
  module Mailer
    class Message
      include Virtus
      include Aequitas
      include Tinto::Exceptions


      QUEUE_KEY       = 'sendmail'
      MODEL_NAME      = 'message'
      TEMPLATE_KINDS  = Config::MAILER_TEMPLATES.keys.map(&:to_s)

      attribute :from,          String
      attribute :to,            String
      attribute :subject,       String
      attribute :template,      String
      attribute :locale,        String
      attribute :substitutions, Hash

      validates_presence_of     :from, :to, :subject, :template, :locale

      validates_within          :template, set: TEMPLATE_KINDS
      validates_within          :locale,   
                                  set: I18n.available_locales.map(&:to_s)

      def initialize(*args)
        super(*args)
      end #initialize

      def prepare(method, *args)
        message.attributes = self.send(method, *args)
        raise InvalidResource unless valid?
      end #prepare

      def queue
        raise InvalidResource unless valid?
        $redis.rpush QUEUE_KEY, self.attributes.to_json
      end #queue

      alias_method :sync, :queue
      
      def invitation_for(actor, invitation, entity)
        base_path = "https://#{Belinkr::Config::HOSTNAME}/invitations"
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
            invitation_link:  "#{base_path}/#{invitation.id}"
          }
        }
      end

      def reset_for(actor, reset)
        base_path = "https://#{Belinkr::Config::HOSTNAME}/resets"
        {
          from:           'belinkr <helpbelinkr.com>',
          to:             "#{actor.name} <#{reset.email}>",
          subject:        I18n::t('mailer.reset.subject'),
          template:       'reset',
          locale:         reset.locale,
          substitutions:  {
                            user_name:  actor.name,
                            reset_link: "#{base_path}/#{reset.id}"
                          }
        }
      end #invitation_for
    end # Message
  end # Mailer
end # Belinkr
