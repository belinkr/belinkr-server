# encoding: utf-8
require_relative 'Random'
require_relative '../../App/Reset/Member'

module Belinkr
  class Factory
    def self.reset(attrs={})
      Reset::Member.new(
        email:          attrs[:email]       || "#{random_string}@belinkr.com",
        credential_id:  attrs[:inviter_id]  || random_uuid
      )
    end
  end # Factory
end # Belinkr
