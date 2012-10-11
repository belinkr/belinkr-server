# encoding: utf-8
require 'virtus'
require 'aequitas'
require_relative 'Member'
require_relative '../../Tinto/SortedSet'

module Belinkr
  module Invitation
    class Collection
      extend Forwardable
      include Virtus
      include Aequitas
      include Enumerable

      MODEL_NAME = 'invitation'

      attribute :entity_id,       Integer

      validates_presence_of       :entity_id
      validates_numericalness_of  :entity_id

      def_delegators :@zset,      :each, :size, :length, :include?, :empty?,
                                  :exists?, :all, :page, :<<, :add, :remove,
                                  :delete, :merge, :score

      def initialize(attributes={}, members=[])
        super attributes
        @zset = Tinto::SortedSet
          .new(self, Invitation::Member, storage_key, members)
      end

      def member_init_params
        { entity_id: entity_id }
      end

      private

      def storage_key
        "entities:#{entity_id}:invitations"
      end
    end # Collection
  end # Invitation
end # Belinkr
