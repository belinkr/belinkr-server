# encoding: utf-8
require 'virtus'
require 'aequitas'
require_relative 'Member'
require 'Tinto/Set'

module Belinkr
  module Workspace
    class Collection
      extend Forwardable
      include Virtus
      include Aequitas
      include Enumerable
      
      MODEL_NAME = 'workspace'

      attribute :entity_id,     String
      validates_presence_of     :entity_id

      def_delegators :@set,     *Tinto::Set::INTERFACE

      def initialize(attributes={}, storage_key=nil)
        self.attributes =  attributes
        @storage_key    = storage_key
        @set            = Tinto::Set.new self
      end #initialize

      def instantiate_member(attributes={})
        Member.new attributes.merge(entity_id: entity_id)
      end #instantiate_member

      def storage_key
        @storage_key || "entities:#{entity_id}:workspaces"
      end #storage_key
    end # Collection
  end # Workspace
end # Belinkr

