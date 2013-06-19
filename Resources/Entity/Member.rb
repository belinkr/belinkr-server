# encoding: utf-8
require 'forwardable'
require 'virtus'
require 'aequitas'
require 'Tinto/Member'

module Belinkr
  module Entity
    class Member
      extend Forwardable
      include Virtus
      include Aequitas

      MODEL_NAME  = 'entity'
      WHITELIST   = %w{ name short_name }

      attribute :id,              String
      attribute :name,            String
      attribute :short_name,      String
      attribute :created_at,      Time
      attribute :updated_at,      Time
      attribute :deleted_at,      Time

      validates_presence_of       :id, :name
      validates_length_of         :name, min: 2, max: 150

      def_delegators :@member,    *Tinto::Member::INTERFACE

      def initialize(attributes={})
        self.attributes = attributes
        @member         = Tinto::Member.new self
      end #initialize

      def storage_key
        'entities'
      end #storage_key
    end # Member
  end # Entity
end # Belinkr

