# encoding: utf-8
require_relative '../../Locales/Loader'
require_relative '../Reset/Collection'
require_relative '../../Workers/Mailer/Message'

class RequestPasswordReset
  BASE_PATH = "https://#{Belinkr::Config::HOSTNAME}/resets"

  def initialize(actor, reset)
    @actor  = actor
    @reset  = reset
    @resets = Reset::Collection.new
  end

  def call
    @reset.save
    @resets.add @reset
    Mailer::Message.new(message_for @actor, @reset).queue
    @reset
  end

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

