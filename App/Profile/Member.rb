# encoding: utf-8
require 'forwardable'
require 'virtus'
require 'aequitas'
require_relative '../../Tinto/Member'
require_relative '../../Config'

module Belinkr
  module Profile
    class Member
      extend Forwardable
      include Virtus
      include Aequitas

      MODEL_NAME  = 'profile'
      WHITELIST   = 'mobile landline fax position department'

      attribute :id,              Integer
      attribute :mobile,          String
      attribute :landline,        String
      attribute :fax,             String
      attribute :position,        String
      attribute :department,      String
      attribute :entity_id,       Integer
      attribute :user_id,         Integer
      attribute :created_at,      Time
      attribute :updated_at,      Time
      attribute :deleted_at,      Time

      validates_numericalness_of  :entity_id, :user_id
      validates_presence_of       :entity_id, :user_id
      validates_length_of         :mobile,      max: 50
      validates_length_of         :landline,    max: 50
      validates_length_of         :fax,         max: 50
      validates_length_of         :position,    max: 250
      validates_length_of         :department,  max: 250

      def_delegators :@member,    :==, :score, :to_json, :read, :save, :update,
                                  :sanitize, :delete, :undelete, :destroy

      alias_method :to_hash, :attributes

      def initialize(attrs={}, retrieve=true)
        super attrs
        @member = Tinto::Member.new self, retrieve
      end

      def storage_key
        "entities:#{entity_id}:profiles"
      end

      def user
        @user ||= User::Member.new(id: user_id)
      end
    end # Member
  end # Profile
end # Belinkr

