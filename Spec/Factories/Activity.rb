# encoding: utf-8
require_relative 'Random'
require_relative '../../Resources/Activity/Member'

module Belinkr
  class Factory
    def self.activity(attrs={})
      Activity::Member.new(
        actor:        attrs[:actor]       || random_string,
        action:       attrs[:action]      || random_string,
        object:       attrs[:object]      || random_string,
        target:       attrs[:target]      || random_string,
        description:  attrs[:description] || random_string,
        entity_id:    attrs[:entity_id]   || random_uuid
      )
    end
  end # Factory
end # Belinkr
