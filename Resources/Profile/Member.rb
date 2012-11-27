# encoding: utf-8
require 'forwardable'
require 'virtus'
require 'aequitas'
require 'Tinto/Member'

module Belinkr
  module Profile
    class Member
      extend Forwardable
      include Virtus
      include Aequitas

      MODEL_NAME          = 'profile'
      WHITELIST           = 'mobile landline fax position department'
      TIMELINES           = %w{ own general replies files workspaces
                                forwarded_by_you forwarded_by_others }
      FOLLOWER_TIMELINES  = %w{ general files }

      attribute :id,                String
      attribute :mobile,            String
      attribute :landline,          String
      attribute :fax,               String
      attribute :position,          String
      attribute :department,        String
      attribute :entity_id,         String
      attribute :user_id,           String
      attribute :created_at,        Time
      attribute :updated_at,        Time
      attribute :deleted_at,        Time
      attribute :following_counter, Integer, default: 0
      attribute :followers_counter, Integer, default: 0
      attribute :status_counter,    Integer, default: 0

      validates_presence_of         :id, :entity_id, :user_id,
                                    :followers_counter, :following_counter,
                                    :status_counter
      validates_length_of           :mobile,      max: 50
      validates_length_of           :landline,    max: 50
      validates_length_of           :fax,         max: 50
      validates_length_of           :position,    max: 250
      validates_length_of           :department,  max: 250
      validates_numericalness_of    :followers_counter, :following_counter,
                                    :status_counter

      def_delegators :@member,      *Tinto::Member::INTERFACE

      def initialize(attrs={})
        super attrs
        @member = Tinto::Member.new self
      end #initialize

      def storage_key
        "entities:#{entity_id}:profiles"
      end #storage_key

      def user
        User::Member.new(id: user_id)
      end #user

      def link_to(entity)
        self.entity_id = entity.id
        self
      end #link_to

      def increment_followers_counter
        self.followers_counter = self.followers_counter + 1
      end #increment_followers_counter

      def decrement_followers_counter
        self.followers_counter = self.followers_counter - 1
      end #decrement_followers_counter

      def increment_following_counter
        self.following_counter = self.following_counter + 1
      end #increment_following_counter

      def decrement_following_counter
        self.following_counter = self.following_counter - 1
      end #decrement_following_counter

      def increment_status_counter
        self.status_counter = self.status_counter + 1
      end #increment_status_counter

      def decrement_status_counter
        self.status_counter = self.status_counter - 1
      end #decrement_status_counter
    end # Member
  end # Profile
end # Belinkr

