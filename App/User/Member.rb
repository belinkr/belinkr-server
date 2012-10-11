# encoding: utf-8
require 'forwardable'
require 'virtus'
require 'aequitas'
require 'bcrypt'
require_relative './Member'
require_relative '../../Tinto/Member'
require_relative '../../Tinto/Utils'
require_relative '../../Config'

module Belinkr
  module User
    class Member
      extend Forwardable
      include Virtus
      include Aequitas

      MODEL_NAME  = 'user'
      WHITELIST   = %w{ avatar first last name_order password locale timezone }

      attribute :id,              Integer
      attribute :avatar,          String
      attribute :first,           String
      attribute :last,            String
      attribute :email,           String
      attribute :name_order,      String, default: 'first-last'
      attribute :password,        String
      attribute :locale,          String, default: Config::DEFAULT_LOCALE
      attribute :timezone,        String
      attribute :profile_ids,     Array[Integer], default: []
      attribute :entity_ids,      Array[Integer], default: []
      attribute :created_at,      Time
      attribute :updated_at,      Time
      attribute :deleted_at,      Time

      validates_presence_of       :first, :last, :password, :name_order
      validates_presence_of       :email
      validates_format_of         :email, as: :email_address
      validates_length_of         :password, min: 1, max: 150
      validates_length_of         :first, max: 50
      validates_length_of         :last,  max: 50

      def_delegators :@member,    :==, :score, :to_json, :read, :save, :update,
                                  :sanitize, :delete, :undelete, :destroy

      alias_method :to_hash, :attributes

      def initialize(attrs={}, retrieve=true)
        super attrs
        @member = Tinto::Member.new self, retrieve
      end

      def save(context=nil)
        self.password = BCrypt::Password.create(password) unless encrypted?
        @member.save(context=nil)
      end

      def storage_key
        'users'
      end

      def name
        return "#{first} #{last}" if name_order == 'first-last'
        return "#{last} #{first}" if name_order == 'last-first'
      end

      def encrypted?
        Tinto::Utils.bcrypted?(password)
      end

      alias_method :search_index, :storage_key

      def index_path
        "#{MODEL_NAME}/#{id}"
      end
    end # Member
  end # User
end # Belinkr

