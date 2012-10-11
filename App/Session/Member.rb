# encoding: utf-8
require 'securerandom'
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
      attribute :user_id,         Integer
      attribute :profile_id,      Integer
      attribute :entity_id,       Integer
      attribute :created_at,      Time
      attribute :updated_at,      Time
      attribute :deleted_at,      Time

      validates_presence_of       :id, :user_id, :profile_id, :entity_id
      validates_numericalness_of  :user_id, :profile_id, :entity_id

      def_delegators :@member,    :==, :score, :to_json, :read, :save, :update, 
                                  :delete, :undelete, :destroy, :sanitize 

      alias_method :to_hash, :attributes

      def_delegators :credential, :jid
      def initialize(attributes={}, retrieve=true)
        super attributes
        @member = Tinto::Member.new self, retrieve
      end

      def save
        self.id = SecureRandom.urlsafe_base64(64)
        @member.save
      end

      def storage_key
        'sessions'
      end
    end # Member
  end # Session
end # Belinkr
