# encoding: utf-8
require_relative './Random'
require_relative './Profile'
require_relative '../../Data/User/Member'

module Belinkr
  class Factory
    def self.user(attrs={})
      User::Member.new(
        first:        attrs[:first]       || random_string,
        last:         attrs[:last]        || random_string,
        email:        attrs[:email]       || "#{random_string}@belinkr.com",
        password:     attrs[:password]    || random_string,
        profiles:     attrs[:profiles]    || [Factory.profile],
      )
    end
  end # Factory
end # Belinkr
