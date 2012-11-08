# encoding: utf-8
require 'forwardable'
require 'virtus'
require 'aequitas'
require_relative '../../Tinto/Member'

module Belinkr
  module Entity
    class Member
      extend Forwardable
      include Virtus
      include Aequitas

      MODEL_NAME  = 'entity'
      WHITELIST   = %w{ name }
 
      attribute :id,              String
      attribute :name,            String
      attribute :created_at,      Time
      attribute :updated_at,      Time
      attribute :deleted_at,      Time

      validates_presence_of       :id, :name
      validates_length_of         :name, min: 2, max: 150

      def_delegators :@member,    *Tinto::Member::INTERFACE

      def initialize(attrs={})
        super attrs
        @member = Tinto::Member.new self
      end

      def storage_key
        'entities'
      end

      alias_method :search_index, :storage_key

    end # Member
  end # Entity
end # Belinkr

