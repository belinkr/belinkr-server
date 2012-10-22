# encoding: utf-8
require_relative './Random'
require_relative '../../App/Status/Member'

module Belinkr
  class Factory
    def self.status(attrs={})
      Status::Member.new(
        id:             attrs[:id]            || random_uuid,
        user_id:        attrs[:user_id]       || random_uuid,
        text:           attrs[:text]          || random_string,
        files:          attrs[:files]         || [],
        workspace_id:   attrs[:workspace_id],
        scrapbook_id:   attrs[:scrapbook_id],
        credential_id:  attrs[:credential_id],
        entity_id:      attrs[:entity_id]     || 0,
      )
    end
  end # Factory
end # Belinkr
