# encoding: utf-8
require 'virtus'
require 'aequitas'
require_relative '../Polymorphic/Polymorphic'

module Belinkr
  module Reply
    class Member
      include Virtus
      include Aequitas

      MODEL_NAME  = "reply"
      WHITELIST   = %w{ text files }

      attribute :id,              String
      attribute :text,            String
      attribute :author,          Polymorphic
      attribute :files,           Set[String], default: Set.new
      attribute :status_id,       Integer
      attribute :created_at,      Time
      attribute :updated_at,      Time

      validates_presence_of       :author, :text, :status_id
      validates_length_of         :text, min: 1, max: 10000

      alias_method :to_hash, :attributes

      def initialize(attributes={})
        self.attributes = whitelist(attributes)
        self.id         ||= UUIDTools::UUID.timestamp_create.to_s
        self.created_at ||= Time.now
        self.updated_at ||= Time.now
      end #initialize

      def ==(other)
        to_hash.to_s == other.to_hash.to_s
      end #==

      def to_json(*args)
        attributes.to_hash.merge(files: files.to_a).to_json(*args)
      end #to_json

      def whitelist(attributes)
        attributes.each { |key, value| nilify_unless_whitelisted(key) }
        self
      end #whitelist

      def nilify_unless_whitelisted(attribute)
        send(:"#{attribute}=", nil) unless WHITELIST.include?(attribute.to_s)
      end #nilify_unless_whitelisted

      def files?
        !files.empty?
      end #files?
    end # Reply
  end # Member
end # Belinkr

