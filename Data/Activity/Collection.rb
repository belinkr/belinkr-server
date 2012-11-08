# encoding: utf-8
require 'forwardable'
require 'virtus'
require 'aequitas'
require_relative './Member'
require_relative '../../Tinto/SortedSet'

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

      def initialize(*args)
        super *args
        @zset = Tinto::SortedSet.new self
      end

      def instantiate_member(attributes={})
        Member.new attributes.merge(entity_id: entity_id)
      end

      def storage_key
        "entities:#{entity_id}:activities"
      end
    end # Collection
  end # Activity
end # Belinkr

