# encoding: utf-8
require 'forwardable'
require 'virtus'
require 'aequitas'
require 'Tinto/Set'
require_relative '../User/Member'

module Belinkr
  module Following
    class Collection
      extend Forwardable
      include Virtus
      include Aequitas
      include Enumerable

      MODEL_NAME  = 'following'

      attribute :user_id,     String
      attribute :entity_id,   String

      validates_presence_of   :user_id, :entity_id

      def_delegators :@set,   *Tinto::Set::INTERFACE

      def initialize(attributes={})
        self.attributes = attributes
        @set = Tinto::Set.new self
      end #initialize

      def instantiate_member(attributes={})
        User::Member.new(attributes)
      end #instantiate_member

      def storage_key
        "entities:#{entity_id}:users:#{user_id}:following"
      end #storage_key
    end # Collection
  end # Following
end # Belinkr

