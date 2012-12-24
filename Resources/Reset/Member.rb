# encoding: utf-8
require 'forwardable'
require 'virtus'
require 'aequitas'
require 'Tinto/Member'

module Belinkr
  module Reset
    class Member
      extend Forwardable
      include Virtus
      include Aequitas

      MODEL_NAME = 'reset'

      attribute :id,              String
      attribute :user_id,         String
      attribute :email,           String
      attribute :locale,          String, default: 'en'
      attribute :created_at,      Time
      attribute :updated_at,      Time
      attribute :deleted_at,      Time

      validates_presence_of       :id, :email
      validates_format_of         :email, as: :email_address

      def_delegators :@member,    *Tinto::Member::INTERFACE

      def initialize(attributes={})
        self.attributes = attributes
        @member         = Tinto::Member.new self
      end #initialize

      def storage_key
        'resets'
      end #storage_key

      def link_to(actor)
        self.email    = actor.email
        self.user_id  = actor.id
        self
      end #link_to
    end # Member
  end # Reset
end # Belinkr

