# encoding: utf-8
require 'forwardable'
require 'virtus'
require 'aequitas'
require_relative '../Profile/Member'
require_relative '../../Tinto/SortedSet'

module Belinkr
  module Following
    class Collection
      extend Forwardable
      include Virtus
      include Aequitas
      include Enumerable

      MODEL_NAME  = 'following'

      attribute :user_id,           Integer
      attribute :entity_id,         Integer

      validates_presence_of         :user_id
      validates_numericalness_of    :user_id
      validates_presence_of         :entity_id
      validates_numericalness_of    :entity_id

      def_delegators :@zset,        :each, :size, :length, :include?, :empty?,
                                    :exists?, :all, :page, :<<, :add, :remove, 
                                    :delete, :merge, :score, :page_size

      def initialize(attributes={}, members=[])
        super attributes
        @zset = Tinto::SortedSet
                        .new(self, Profile::Member, storage_key, members)
      end

      def member_init_params
        { entity_id: entity_id }
      end

      private

      def storage_key
        "entities:#{entity_id}:users:#{user_id}:following"
      end
    end # Collection
  end # Following
end # Belinkr
