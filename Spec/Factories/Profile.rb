# encoding: utf-8
require_relative 'Random'
require_relative '../../App/Profile/Member'

module Belinkr
  class Factory
    def self.profile(attrs={})
      Profile::Member.new(
        id:           attrs[:id]          || random_uuid,
        user_id:      attrs[:user_id]     || random_uuid,
        entity_id:    attrs[:entity_id]   || random_uuid,
        position:     attrs[:position]    || random_string,
        mobile:       attrs[:mobile]      || random_string
      )
    end
  end # Factory
end # Belinkr
