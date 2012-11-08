# encoding: utf-8
require 'forwardable'
require 'virtus'
require 'aequitas'
require_relative '../../Tinto/Member'

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

      attribute :id,              String
      attribute :mobile,          String
      attribute :landline,        String
      attribute :fax,             String
      attribute :position,        String
      attribute :department,      String
      attribute :entity_id,       String
      attribute :user_id,         String
      attribute :created_at,      Time
      attribute :updated_at,      Time
      attribute :deleted_at,      Time

      validates_presence_of       :id, :entity_id, :user_id
      validates_length_of         :mobile,      max: 50
      validates_length_of         :landline,    max: 50
      validates_length_of         :fax,         max: 50
      validates_length_of         :position,    max: 250
      validates_length_of         :department,  max: 250

      def_delegators :@member,    *Tinto::Member::INTERFACE

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
    end # Member
  end # Profile
end # Belinkr

