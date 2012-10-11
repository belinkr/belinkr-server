# encoding: utf-8
require_relative 'Random'
require_relative '../../App/User/Member'

module Belinkr
  class Factory
    def self.user(attrs={})
      User::Member.new(
        {
          id:           attrs[:id]          || random_number,
          first:        attrs[:first]       || random_string,
          last:         attrs[:last]        || random_string,
          email:        attrs[:email]       || "#{random_string}@belinkr.com",
          password:     attrs[:password]    || random_string,
          profile_ids:  attrs[:profile_ids] || [random_number],
          entity_ids:   attrs[:entity_ids]  || [random_number] 
        },
        false
      )
    end
  end # Factory
end # Belinkr
