# encoding: utf-8
require_relative 'Random'
require_relative '../../Data/Invitation/Member'

module Belinkr
  class Factory
    def self.invitation(attrs={})
      Invitation::Member.new(
        inviter_id:     attrs[:inviter_id]    || random_uuid,
        invited_name:   attrs[:invited_name]  || random_string,
        invited_email:  attrs[:invited_email] || "#{random_string}@foo.com",
        locale:         attrs[:locale]        || 'en',
        entity_id:      attrs[:entity_id]     || random_uuid
      )
    end
  end # Factory
end # Belinkr

