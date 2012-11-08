# encoding: utf-8
require_relative './Random'
require_relative '../../Data/Workspace/Member'

module Belinkr
  class Factory
    def self.workspace(attrs={})
      Workspace::Member.new(
        id:         attrs[:id]        || random_uuid,
        name:       attrs[:name]      || random_string,
        entity_id:  attrs[:entity_id] || random_uuid
      )
    end
  end # Factory
end # Belinkr
