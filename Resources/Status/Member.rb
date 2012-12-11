# encoding: utf-8
require 'forwardable'
require 'virtus'
require 'aequitas'
require 'Tinto/Member'
require_relative '../Polymorphic/Polymorphic'
#require_relative '../reply/collection'

module Belinkr
  module Status
    class Member
      extend Forwardable
      include Virtus
      include Aequitas

      MODEL_NAME  = 'status'
      WHITELIST   = %w{ text files }

      attribute :id,                String
      attribute :text,              String
      attribute :author,            Polymorphic
      attribute :forwarder,         Polymorphic
      attribute :scope,             Polymorphic
      attribute :files,             Array, default: []
      #attribute :replies,           Array[Reply::Member], default: []
      attribute :created_at,        Time 
      attribute :updated_at,        Time 
      attribute :deleted_at,        Time

      validates_presence_of         :author, :text
      validates_length_of           :text, min: 1, max: 10000

      def_delegators :@member,      *Tinto::Member::INTERFACE

      def initialize(attributes={})
        self.attributes = attributes
        @member = Tinto::Member.new self
      end

      #def replies
      #  Reply::Collection.new(super)
      #end

      def files?
        !files.empty?
      end #files?

      def scope=(new_scope)
        return unless new_scope.respond_to? :storage_key

        @base_storage_key = "#{new_scope.storage_key}:#{new_scope.id}"
        super new_scope
      end #scope=

      def storage_key
        "#{base_storage_key}:statuses"
      end

      private
      
      attr_reader :base_storage_key
    end # Member
  end # Status
end # Belinkr

