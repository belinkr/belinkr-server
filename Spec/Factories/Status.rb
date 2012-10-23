# encoding: utf-8
require_relative './Random'
require_relative '../../App/Status/Member'

module Belinkr
  class Factory
    def self.status(attrs={})
      Status::Member.new(
        id:             attrs[:id]            || random_uuid,
        author:         attrs[:author],
        text:           attrs[:text]          || random_string,
        files:          attrs[:files]         || [],
        contexts:       attrs[:contexts]
      )
    end
  end # Factory
end # Belinkr
