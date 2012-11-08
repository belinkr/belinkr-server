# encoding: utf-8
require_relative './Random'
require_relative '../../Data/Scrapbook/Member'

module Belinkr
  class Factory
    def self.scrapbook(attrs={})
      Scrapbook::Member.new(
        id:       attrs[:id]      || random_uuid,
        name:     attrs[:name]    || random_string,
        user_id:  attrs[:user_id] || random_uuid
      )
    end
  end # Factory
end # Belinkr
