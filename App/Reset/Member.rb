# encoding: utf-8
require 'forwardable'
require 'virtus'
require 'aequitas'
require_relative '../../Tinto/Member'
require_relative '../../Tinto/Utils'

module Belinkr
  module Reset
    class Member
      extend Forwardable
      include Virtus
      include Aequitas

      MODEL_NAME = 'reset'

      attribute :id,              String
      attribute :user_id,         Integer
      attribute :email,           String
      attribute :locale,          String, default: 'en'
      attribute :created_at,      Time
      attribute :updated_at,      Time
      attribute :deleted_at,      Time

      validates_presence_of       :id, :email
      validates_format_of         :email, as: :email_address
      validates_with_block        :id do Tinto::Utils.is_sha256?(@id) end
      validates_numericalness_of  :user_id, allow_nil: true

      def_delegators :@member,    :==, :score, :to_json, :read, :save, :update, 
                                  :delete, :undelete, :sanitize

      alias_method :to_hash, :attributes

      def initialize(attrs={}, retrieve=true)
        super attrs
        @member = Tinto::Member.new self, retrieve
        self.id ||= Tinto::Utils.generate_token
      end

      def storage_key
        'resets'
      end
    end # Member
  end # Reset
end # Belinkr
