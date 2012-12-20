# encoding: utf-8
require 'virtus'
require 'aequitas'
require 'Tinto/Set'
require_relative 'Member'

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

        def initialize(attributes={})
          self.attributes = attributes
          @set            = Tinto::Set.new self
        end #initialize

        def instantiate_member(attributes={})
          Member.new attributes.merge(
            entity_id: entity_id, workspace_id: workspace_id
          )
        end #instantiate_member

        def storage_key
          "entities:#{entity_id}:workspaces:#{workspace_id}:invitations"
        end #storage_key
      end # Collection
    end # Invitation
  end # Workspace
end # Belinkr

