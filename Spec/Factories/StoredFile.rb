# encoding: utf-8
require_relative '../../Resources/StoredFile/Member'

module Belinkr
  class Factory
    def self.stored_file(attrs={})
      StoredFile::Member.parse({ 
        type:       attrs[:type]      || 'text/plain',
        filename:   attrs[:filename]  || 'foo.txt', 
        tempfile:   attrs[:tempfile]  || 
                      File.open("#{File.dirname(__FILE__)}/../Support/foo.txt"),
        entity_id:  attrs[:entity_id] || 0
      })
    end

    def self.text_file(attrs={})
      StoredFile::Member.parse({ 
        type:       'text/plain',
        filename:   'foo.txt', 
        tempfile:   File.open("#{File.dirname(__FILE__)}/../Support/foo.txt"),
        entity_id:  attrs[:entity_id] || 0
      })
    end

    def self.image_file(attrs={})
      StoredFile::Member.parse({
        type:       'image/png',
        filename:   'logo.png',
        tempfile:   File.open("#{File.dirname(__FILE__)}/../Support/logo.png"),
        entity_id:  attrs[:entity_id] || 0
      })
    end

    def self.image_file_no_ext(attrs={})
      StoredFile::Member.parse({
        type:       'application/octet-stream',
        filename:   'logo_no',
        #tempfile:   File.open("#{File.dirname(__FILE__)}/../Support/logo_no"),
        entity_id:  attrs[:entity_id] || 0
      })
    end
  end # Factory
end # Belinkr

