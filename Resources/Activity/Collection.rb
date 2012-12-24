# encoding: utf-8
require 'forwardable'
require 'virtus'
require 'aequitas'
require 'Tinto/SortedSet'
require_relative './Member'

module Belinkr
  module Activity
    class Collection
      extend Forwardable
      include Virtus
      include Aequitas
      include Enumerable

      MODEL_NAME = 'activity'

      attribute :entity_id,   String
      validates_presence_of   :entity_id

      def_delegators :@zset,  *Tinto::SortedSet::INTERFACE

      def initialize(attributes={})
        self.attributes = attributes
        @zset           = Tinto::SortedSet.new self
      end #initialize

      def instantiate_member(attributes={})
        Member.new attributes.merge(entity_id: entity_id)
      end #instantiate_member

      def storage_key
        "entities:#{entity_id}:activities"
      end #storage_key
    end # Collection
  end # Activity
end # Belinkr

