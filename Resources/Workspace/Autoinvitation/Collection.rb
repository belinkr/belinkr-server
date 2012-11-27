# encoding: utf-8
require 'virtus'
require 'aequitas'
require_relative 'Member'
require 'Tinto/Set'

module Belinkr
  module Workspace
    module Autoinvitation
      class Collection
        extend Forwardable
        include Virtus
        include Aequitas
        include Enumerable

        MODEL_NAME = 'autoinvitation'

        attribute :workspace_id,    String
        attribute :entity_id,       String

        validates_presence_of       :workspace_id, :entity_id

        def_delegators :@set, *Tinto::Set::INTERFACE

        def initialize(attributes={})
          super attributes
          @set = Tinto::Set.new self
        end

        def instantiate_member(attributes={})
          Member.new attributes.merge(
            entity_id: entity_id, workspace_id: workspace_id
          )
        end

        def storage_key
          "entities:#{entity_id}:workspaces:#{workspace_id}:autoinvitations"
        end
      end # Collection
    end # Autoinvitation
  end # Workspace
end # Belinkr
