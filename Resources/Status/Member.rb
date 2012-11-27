# encoding: utf-8
require 'forwardable'
require 'virtus'
require 'aequitas'
require_relative '../Polymorphic/Polymorphic'
require 'Tinto/Member'
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
      attribute :contexts,          Array[Polymorphic], default: []
      attribute :files,             Array, default: []
      #attribute :replies,           Array[Reply::Member], default: []
      attribute :forwarder,         Polymorphic
      attribute :created_at,        Time 
      attribute :updated_at,        Time 
      attribute :deleted_at,        Time

      #validates_presence_of         :author, :text
      #validates_length_of           :text, min: 1, max: 10000

      def_delegators :@member,      *Tinto::Member::INTERFACE

      def initialize(attributes={})
        super attributes
        @member = Tinto::Member.new self
      end

      #def replies
      #  Reply::Collection.new(super)
      #end

      def storage_key
        "#{context.storage_key}:#{context.id}:statuses"
      end
    end # Member
  end # Status
end # Belinkr
