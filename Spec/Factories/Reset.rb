# encoding: utf-8
require_relative 'Random'
require_relative '../../App/Reset/Member'
require_relative '../../Tinto/Utils'

module Belinkr
  class Factory
    def self.reset(attrs={})
      Reset::Member.new(
        {
          id:             attrs[:id]          || Tinto::Utils.generate_token,
          email:          attrs[:email]       || "#{random_string}@belinkr.com",
          credential_id:  attrs[:inviter_id]  || random_number
        },
        false
      )
    end
  end # Factory
end # Belinkr
