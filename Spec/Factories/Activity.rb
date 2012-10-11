# encoding: utf-8
require_relative 'Random'
require_relative '../../App/User/Member'

module Belinkr
  class Factory
    def self.activity(attrs={})
      Activity::Member.new(
        {
          id:           attrs[:id]          || random_number,
          actor:        attrs[:actor]       || random_string,
          action:       attrs[:action]      || random_string,
          object:       attrs[:object]      || random_string,
          target:       attrs[:target]      || random_string,
          description:  attrs[:description] || random_string,
          entity_id:    attrs[:entity_id]   || 0
        },
        false
      )
    end
  end # Factory
end # Belinkr
