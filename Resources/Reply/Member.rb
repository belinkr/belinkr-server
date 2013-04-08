# encoding: utf-8
require 'forwardable'
require 'virtus'
require 'aequitas'
require 'Tinto/Member'
require_relative '../Polymorphic/Polymorphic'

module Belinkr
  module Reply
    class Member
      extend Forwardable
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

      def_delegators :@member,    *Tinto::Member::INTERFACE


      def initialize(attributes={})
        self.attributes = attributes
        @member         = Tinto::Member.new self
      end #initialize

      def to_json(*args)
        attributes.to_hash.merge(files: files.to_a).to_json(*args)
      end #to_json

      def files?
        !files.empty?
      end #files?

      def storage_key
        "#{base_storage_key}:replies"
      end #storage_key

      private

      def base_storage_key

      end

    end # Reply
  end # Member
end # Belinkr

