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

      validates_presence_of       :name, :entity_id
      validates_length_of         :name, min: 1, max: 250

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
    end # Member
  end # Workspace
end # Belinkr
