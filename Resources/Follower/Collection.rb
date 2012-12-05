# encoding: utf-8
require 'forwardable'
require 'virtus'
require 'aequitas'
require 'Tinto/Set'
require_relative '../User/Member'

module Belinkr
  module Follower
    class Collection
      extend Forwardable
      include Virtus
      include Aequitas
      include Enumerable

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
        User::Member.new(attributes).fetch
      end

      def storage_key
        "entities:#{entity_id}:users:#{user_id}:followers"
      end
    end # Collection
  end # Follower
end # Belinkr

