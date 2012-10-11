# encoding: utf-8
require 'forwardable'
require 'aequitas'
require_relative 'Member'
require_relative '../../Tinto/SortedSet'

module Belinkr
  module Entity
    class Collection
      extend Forwardable
      include Enumerable
      include Aequitas

      MODEL_NAME  = 'entity'

      def_delegators :@zset,  :each, :size, :length, :include?, :empty?,
                              :exists?, :all, :page, :<<, :add, :remove, 
                              :delete, :merge, :score

      def initialize(attributes={}, members=[])
        @zset = Tinto::SortedSet.new(self, Entity::Member, storage_key, members)
      end

      private

      def storage_key
        'entities'
      end
    end # Collection
  end # Entity
end # Belinkr
