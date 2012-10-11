# encoding: utf-8
require 'virtus'
require 'aequitas'
require_relative 'Member'
require_relative '../../Tinto/SortedSet'

module Belinkr
  module Reset
    class Collection
      extend Forwardable
      include Enumerable
      include Virtus
      include Aequitas

      def_delegators :@zset,    :each, :size, :length, :include?, :empty?,
                                :exists?, :all, :page, :<<, :add, :remove,
                                :delete, :merge, :score

      def initialize(attributes={}, members=[])
        super attributes
        @zset = Tinto::SortedSet.new(self, Reset::Member, storage_key, members)
      end

      private

      def storage_key
        'resets'
      end
    end # Collection
  end # Reset
end # Belinkr
