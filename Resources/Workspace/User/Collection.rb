# encoding: utf-8
require 'virtus'
require 'aequitas'
require 'Tinto/Set'
require_relative '../../User/Member'

module Belinkr
  module Workspace
    module User
      class Collection
        extend Forwardable
        include Virtus
        include Aequitas
        include Enumerable

        MODEL_NAME  = 'user'
        KINDS       = %w{ collaborator administrator invited autoinvited }

        attribute :workspace_id,  String
        attribute :entity_id,     String
        attribute :kind,          String

        validates_presence_of     :workspace_id, :entity_id, :kind
        validates_within          :kind, set: KINDS

        def_delegators :@set,     *Tinto::Set::INTERFACE

        def initialize(attributes={})
          super attributes
          @set = Tinto::Set.new self
        end

        def instantiate_member(attributes)
          User::Member.new attributes
        end

        def storage_key
          "entities:#{entity_id}:workspaces:#{workspace_id}:#{kind}"
        end
      end # Collection
    end # User
  end # Workspace
end # Belinkr
