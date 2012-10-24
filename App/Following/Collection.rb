# encoding: utf-8
require 'forwardable'
require 'virtus'
require 'aequitas'
require_relative '../Profile/Member'
require_relative '../../Tinto/Set'

module Belinkr
  module Following
    class Collection
      extend Forwardable
      include Virtus
      include Aequitas
      include Enumerable

      MODEL_NAME  = 'following'

      attribute :profile_id,  String
      attribute :entity_id,   String

      validates_presence_of   :profile_id, :entity_id

      def_delegators :@set,   *Tinto::Set::INTERFACE

      def initialize(attributes={})
        super attributes
        @set = Tinto::Set.new self
      end

      def instantiate_member(attributes={})
        Profile::Member.new(
          attributes.merge(entity_id: entity_id, profile_id: profile_id)
        )  
      end

      def storage_key
        "entities:#{entity_id}:profiles:#{profile_id}:following"
      end
    end # Collection
  end # Following
end # Belinkr

