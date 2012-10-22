# encoding: utf-8
require 'forwardable'
require 'virtus'
require 'aequitas'
require_relative '../../Tinto/Member'
require_relative '../User/Member'

module Belinkr
  module Session
    class Member
      extend Forwardable
      include Virtus
      include Aequitas

      MODEL_NAME = 'session'

      attribute :id,              String
      attribute :user_id,         String
      attribute :profile_id,      String
      attribute :entity_id,       String
      attribute :created_at,      Time
      attribute :updated_at,      Time
      attribute :deleted_at,      Time

      validates_presence_of       :id, :user_id, :profile_id, :entity_id

      def_delegators :@member,    *Tinto::Member::INTERFACE

      def initialize(attributes={})
        super attributes
        @member = Tinto::Member.new self
      end

      def storage_key
        'sessions'
      end
    end # Member
  end # Session
end # Belinkr

