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
      WHITELIST   = %w{ avatar first last name_order email password 
                        locale timezone }

      attribute :id,              String
      attribute :avatar,          String
      attribute :first,           String
      attribute :last,            String
      attribute :name_order,      String, default: 'first-last'
      attribute :email,           String
      attribute :password,        String
      attribute :profiles,        Array[Profile::Member], default: []
      attribute :locale,          String, default: Belinkr::Config::DEFAULT_LOCALE
      attribute :timezone,        String
      attribute :created_at,      Time
      attribute :updated_at,      Time
      attribute :deleted_at,      Time

      validates_presence_of       :id, :first, :last, :name_order, :email, 
                                  :password
      validates_length_of         :first, max: 50
      validates_length_of         :last,  max: 50
      validates_within            :name_order, set: NAME_ORDERS
      validates_format_of         :email, as: :email_address
      validates_length_of         :password, min: 1, max: 150

      def_delegators :@member,    *Tinto::Member::INTERFACE

      def initialize(attrs={})
        super attrs
        @member = Tinto::Member.new self
      end #initialize

      def storage_key
        'users'
      end #storage_key

      alias_method :search_index, :storage_key

      def index_path
        "#{MODEL_NAME}/#{id}"
      end #index_path

      def name
        return "#{last} #{first}" if name_order == 'last-first'
        "#{first} #{last}"
      end #name

      def password=(plaintext)
        super password_hash_for(plaintext)
      end #password=

      def register_in(user_locator)
        validate!
        user_locator.add(email, id) 
        self
      end #register_in

      def unregister_from(user_locator)
        validate!
        user_locator.delete(email, id)
        self
      end #unregister_from

      def link_to(profile)
        profile.user_id = self.id
        self.profiles   = self.profiles.push(profile)
        self
      end #link_to

      def unlink_from(profile)
        profiles = self.profiles
        profiles.delete(profile)
        self.profiles = profiles
        self.delete if self.profiles.empty?
        self
      end #unlink_from

      def authenticate(session, plaintext)
        raise NotAllowed if self.deleted?
        raise NotAllowed unless password_matches?(plaintext)
        session.user_id     = id
        first_profile       = profiles.first
        session.profile_id  = first_profile.id
        session.entity_id   = first_profile.entity_id
        session
      end #authenticate

      def update_details(arguments)
        profile         = arguments.fetch(:profile)
        user_changes    = arguments.fetch(:user_changes)
        profile_changes = arguments.fetch(:profile_changes)

        unlink_from(profile)
        profile.update(profile_changes)
        link_to(profile)

        self.update(user_changes)
        self
      end

      private

      def password_matches?(plaintext)
        BCrypt::Password.new(password).is_password?(plaintext)
      end #password_matches?

      def password_hash_for(plaintext)
        return plaintext if encrypted?(plaintext)
        BCrypt::Password.create(plaintext)
      end #encrypted_password_for

      def encrypted?(password=@password)
        Tinto::Utils.bcrypted?(password)
      end #encrypted?
    end # Member
  end # User
end # Belinkr 