# encoding: utf-8
require_relative 'Random'
require_relative '../../App/Invitation/Member'
require_relative '../../Tinto/Utils'

module Belinkr
  class Factory
    def self.invitation(attrs={})
      Invitation::Member.new(
        {
          id:             attrs[:id]            || Tinto::Utils.generate_token,
          inviter_id:     attrs[:inviter_id]    || random_number,
          invited_name:   attrs[:invited_name]  || random_string,
          invited_email:  attrs[:invited_email] || "#{random_string}@foo.com",
          locale:         attrs[:locale]        || 'en',
          entity_id:      attrs[:entity_id]     || 0
        },
        false
      )
    end
  end # Factory
end # Belinkr
