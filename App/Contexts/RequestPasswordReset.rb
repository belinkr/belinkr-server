# encoding: utf-8
require_relative '../../Locales/Loader'
require_relative '../Reset/Collection'
require_relative '../../Workers/Mailer/Message'
require_relative '../../Tinto/Context'

module Belinkr
  class RequestPasswordReset
    include Tinto::Context

    BASE_PATH = "https://#{Belinkr::Config::HOSTNAME}/resets"

    def initialize(actor, reset, resets=Reset::Collection.new)
      @actor  = actor
      @reset  = reset
      @resets = resets
    end

    def call
      @reset.email    = @actor.email
      @reset.user_id  = @actor.id

      @reset.verify
      @resets.add @reset
      Mailer::Message.new(message_for @actor, @reset).queue

      @to_sync = [@reset, @resets]
      @reset
    end #call

    private

    def message_for(actor, reset)
      {
        from:           'belinkr <help@belinkr.com>',
        to:             "#{actor.name} <#{reset.email}>",
        subject:        I18n::t('mailer.reset.subject'),
        template:       'reset',
        locale:         reset.locale,
        substitutions:  {
                          user_name:  actor.name,
                          reset_link: "#{BASE_PATH}/#{reset.id}"
                        }
      }
    end
  end # RequestPasswordReset
end # Belinkr

