# encoding: utf-8
require 'forwardable'
require 'virtus'
require 'aequitas'
require_relative './Member'
require_relative '../../Tinto/Set'

module Belinkr
  module Profile
    class Collection
      extend Forwardable
      include Virtus
      include Aequitas

      MODEL_NAME  = 'profile'

      attribute :entity_id,       String
      validates_presence_of       :entity_id

      def_delegators :@set,       *Tinto::Set::INTERFACE

      def initialize(attributes={})
        super attributes
        @set = Tinto::Set.new self
      end

      def instantiate_member(attributes={})
        Member.new attributes.merge(entity_id: entity_id)
      end

      def storage_key
        "entities:#{entity_id}:profiles"
      end
    end # Collection
  end # Profile
end # Belinkr

