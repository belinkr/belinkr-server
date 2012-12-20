# encoding: utf-8
require 'forwardable'
require 'virtus'
require 'aequitas'
require 'Tinto/Member'

module Belinkr
  module Scrapbook
    class Member
      extend Forwardable
      include Virtus
      include Aequitas

      MODEL_NAME  = 'scrapbook'
      WHITELIST   = %w{ name }

      attribute :id,              String
      attribute :name,            String
      attribute :user_id,         String
      attribute :created_at,      Time
      attribute :updated_at,      Time
      attribute :deleted_at,      Time

      validates_presence_of       :name, :user_id
      validates_length_of         :name, min: 1, max: 250

      def_delegators :@member,    *Tinto::Member::INTERFACE

      def initialize(attributes={})
        self.attributes = attributes
        @member = Tinto::Member.new self
      end

      def storage_key
        "users:#{user_id}:scrapbooks"
      end

      def link_to(user)
        self.user_id = user.id
        self
      end #link_to
    end # Member
  end # Scrapbook
end # Belinkr

