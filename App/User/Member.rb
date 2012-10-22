# encoding: utf-8
require 'forwardable'
require 'virtus'
require 'aequitas'
require 'bcrypt'
require_relative '../../Config'
require_relative '../Profile/Member'
require_relative '../../Tinto/Member'
require_relative '../../Tinto/Utils'

module Belinkr
  module User
    class Member
      extend Forwardable
      include Virtus
      include Aequitas

      MODEL_NAME  = 'user'
      NAME_ORDERS = %w{ first-last last-first }
      WHITELIST   = %w{ avatar first last name_order password locale timezone }

      attribute :id,              String
      attribute :avatar,          String
      attribute :first,           String
      attribute :last,            String
      attribute :name,            String, default: lambda { |user, a| 
                                    user.localized_name 
                                  }
      attribute :name_order,      String, default: 'first-last'
      attribute :email,           String
      attribute :password,        String
      attribute :profiles,        Array[Profile::Member], default: []
      attribute :locale,          String, default: Belinkr::Config::DEFAULT_LOCALE
      attribute :timezone,        String
      attribute :created_at,      Time
      attribute :updated_at,      Time
      attribute :deleted_at,      Time

      validates_presence_of       :id, :first, :last, :name, :name_order,
                                  :email, :password
      validates_length_of         :first, max: 50
      validates_length_of         :last,  max: 50
      validates_within            :name_order, set: NAME_ORDERS
      validates_format_of         :email, as: :email_address
      validates_length_of         :password, min: 1, max: 150

      def_delegators :@member,    *Tinto::Member::INTERFACE

      def initialize(attrs={})
        super attrs
        @member = Tinto::Member.new self
      end

      def storage_key
        'users'
      end

      def password=(plaintext)
        super BCrypt::Password.create(plaintext)
      end

      def encrypted?
        Tinto::Utils.bcrypted?(password)
      end

      def localized_name
        return "#{last} #{first}" if name_order == 'last-first'
        "#{first} #{last}"
      end

      alias_method :search_index, :storage_key

      def index_path
        "#{MODEL_NAME}/#{id}"
      end
    end # Member
  end # User
end # Belinkr

