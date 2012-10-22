# encoding: utf-8
require 'forwardable'
require 'virtus'
require 'aequitas'
require_relative '../Profile/Member'
require_relative '../../Tinto/Set'

module Belinkr
  module Follower
    class Collection
      extend Forwardable
      include Virtus
      include Aequitas

      MODEL_NAME  = 'follower'

      attribute :user_id,     String
      attribute :entity_id,   String

      validates_presence_of   :user_id, :entity_id

      def_delegators :@set,   *Tinto::Set::INTERFACE

      def initialize(attributes={})
        super attributes
        @set = Tinto::Set.new self
      end

      def instantiate_member(attributes={})
        Profile::Member.new(attributes)
          .merge(entity_id: entity_id, user_id: user_id)
      end

      def storage_key
        "entities:#{entity_id}:users:#{user_id}:followers"
      end
    end # Collection
  end # Follower
end # Belinkr

