# encoding: utf-8
require_relative 'Random'
require_relative '../../App/Profile/Member'

module Belinkr
  class Factory
    def self.profile(attrs={})
      Profile::Member.new(
        {
          id:           attrs[:id]          || random_number,
          user_id:      attrs[:user_id]     || random_number,
          entity_id:    attrs[:entity_id]   || random_number,
          position:     attrs[:position]    || random_string,
          mobile:       attrs[:mobile]      || random_string
        },
        false
      )
    end
  end # Factory
end # Belinkr
