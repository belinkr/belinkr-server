# encoding: utf-8
require_relative '../../Locales/Loader'
require_relative '../Reset/Collection'
require_relative '../../Tinto/Context'
require_relative '../../Tinto/Exceptions'

module Belinkr
  class RequestPasswordReset
    include Tinto::Context
    include Tinto::Exceptions

    BASE_PATH = "https://#{Belinkr::Config::HOSTNAME}/resets"

    def initialize(actor, reset, resets, message)
      @actor    = actor
      @reset    = reset
      @resets   = resets
      @message  = message
    end

    def call
      @reset.email    = @actor.email
      @reset.user_id  = @actor.id

      @reset.verify
      @resets.add @reset
      @message.attributes = message_for(@actor, @reset)
      raise InvalidResource unless @message.valid?

      @to_sync = [@reset, @resets, @message]
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

