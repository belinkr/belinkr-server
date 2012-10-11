# encoding: utf-8
require 'aequitas'
require_relative 'Member'
require_relative '../../Tinto/SortedSet'

module Belinkr
  module Session
    class Collection
      extend Forwardable
      include Enumerable
      include Aequitas

      def_delegators :@zset,  :each, :size, :length, :include?, :empty?,
                              :exists?, :all, :page, :<<, :add, :remove,
                              :delete, :merge, :score

      def initialize(*args)
        super *args
        @zset = Tinto::SortedSet.new(self, Session::Member, storage_key)
      end

      private

      def storage_key
        'sessions'
      end
    end # Collection
  end # Session
end # Belinkr
