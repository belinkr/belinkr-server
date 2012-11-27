# encoding: utf-8
require 'virtus'
require 'aequitas'
require_relative 'Member'
require 'Tinto/Set'

module Belinkr
  module Workspace
    module Invitation
      class Collection
        extend Forwardable
        include Virtus
        include Aequitas
        include Enumerable

        MODEL_NAME = "invitation"

        attribute :workspace_id,    String
        attribute :entity_id,       String

        validates_presence_of       :workspace_id, :entity_id

        def_delegators :@set,       *Tinto::Set::INTERFACE

        def initialize(*args)
          super *args
          @set = Tinto::Set.new self
        end

        def instantiate_member(attributes={})
          Member.new attributes.merge(
            entity_id: entity_id, workspace_id: workspace_id
          )
        end

        def storage_key
          "entities:#{entity_id}:workspaces:#{workspace_id}:invitations"
        end
      end # Collection
    end # Invitation
  end # Workspace
end # Belinkr
