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
      end

      def queue
        raise Tinto::Exceptions::InvalidResource unless valid?
        $redis.rpush QUEUE_KEY, self.attributes.to_json
      end

      alias_method :sync, :queue
    end # Message
  end # Mailer
end # Belinkr
