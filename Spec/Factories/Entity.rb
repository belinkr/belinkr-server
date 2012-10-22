# encoding: utf-8
require_relative 'Random'
require_relative '../../App/Entity/Member'

module Belinkr
  class Factory
    def self.entity(attrs={})
      Entity::Member.new(
        name:     attrs[:name]    || random_string * 3,
      )
    end
  end # Factory
end # Belinkr
