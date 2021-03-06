# encoding: utf-8
require 'forwardable'
require 'virtus'
require 'aequitas'
require 'Tinto/Member'
require_relative '../Polymorphic/Polymorphic'

module Belinkr
  module Reply
    class Member
    end
  end
end
require_relative '../Status/Member'

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
      attribute :deleted_at,      Time

      validates_presence_of       :author, :text, :status_id
      validates_length_of         :text, min: 1, max: 10000

      alias_method :to_hash, :attributes

      def_delegators :@member,    *Tinto::Member::INTERFACE


      def initialize(attributes={})
        self.attributes = attributes
        @member         = Tinto::Member.new self
      end #initialize

      def to_json(*args)
        include_author_files_hash.to_json(*args)
      end #to_json

      def include_author_files_hash
        attributes.merge!({files: files.to_a, author: author.attributes})
      end

      def files?
        !files.empty?
      end #files?

      def storage_key
        "#{base_storage_key}:replies"
      end #storage_key

      private

      def base_storage_key
        @status ||= Status::Member.new(id: status_id)
        "#{@status.storage_key}:#{status_id}"
      end

    end # Reply
  end # Member
end # Belinkr

