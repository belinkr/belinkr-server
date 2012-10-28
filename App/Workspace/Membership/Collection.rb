# encoding: utf-8
require 'forwardable'
require 'virtus'
require 'aequitas'
require_relative '../../Profile/Member'
require_relative '../../../Tinto/Set'

module Belinkr
  module Workspace
    module Membership
      class Collection
        extend Forwardable
        include Virtus
        include Aequitas
        include Enumerable
        
        MODEL_NAME  = 'membership'
        KINDS       = %w{ collaborator administrator invited autoinvited }

        attribute :kind,          String
        attribute :user_id,       String
        attribute :entity_id,     String

        validates_presence_of     :kind, :user_id, :entity_id
        validates_within          :kind, set: KINDS


        def_delegators :@set,     *Tinto::Set::INTERFACE

        def initialize(attributes={})
          super attributes
          @set = Tinto::Set.new self
        end

        def instantiate_member(attributes={})
          Profile::Member.new attributes.merge(entity_id: entity_id)
        end

        private

        def storage_key
          "entities:#{entity_id}:users:#{user_id}:workspaces:#{kind}"
        end
      end # Collection
    end # Membership
  end # Workspace
end # Belinkr
