# encoding: utf-8
require 'virtus'
require 'aequitas'
require_relative '../../Tinto/Member'

module Belinkr
  module Workspace
    class Member
      extend Forwardable
      include Virtus
      include Aequitas

      MODEL_NAME  = 'workspace'
      WHITELIST   = %{ name }

      attribute :id,              String
      attribute :name,            String
      attribute :entity_id,       String
      attribute :created_at,      Time
      attribute :updated_at,      Time
      attribute :deleted_at,      Time
      attribute :user_counter,    Integer, default: 0
      attribute :status_counter,  Integer, default: 0

      validates_presence_of       :name, :entity_id, :user_counter,
                                  :status_counter
      validates_length_of         :name, min: 1, max: 250
      validates_numericalness_of  :user_counter, :status_counter

      def_delegators :@member,    *Tinto::Member::INTERFACE

      def initialize(attributes={})
        super attributes
        @member = Tinto::Member.new self
      end

      def storage_key
        "entities:#{entity_id}:workspaces"
      end #storage_key

      def link_to(entity)
        self.entity_id = entity.id
        self
      end #link_to

      def increment_user_counter
        self.user_counter = user_counter + 1
      end #increment_user_counter

      def decrement_user_counter
        self.user_counter = user_counter - 1
      end #decrement_user_counter

      def increment_status_counter
        self.status_counter = status_counter + 1
      end #increment_status_counter

      def decrement_status_counter
        self.status_counter = status_counter - 1
      end #decrement_status_counter
    end # Member
  end # Workspace
end # Belinkr
