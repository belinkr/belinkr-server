# encoding: utf-8
require 'forwardable'
require 'virtus'
require 'aequitas'
require_relative 'Member'
require_relative '../../Tinto/SortedSet'

module Belinkr
  module User
    class Collection
      extend Forwardable
      include Virtus
      include Aequitas
      include Enumerable

      MODEL_NAME  = 'user'

      def_delegators :@zset,  :each, :size, :length, :include?, :empty?,
                              :exists?, :all, :page, :<<, :add, :remove, 
                              :delete, :merge, :score

      def initialize(attributes={}, members=[])
        super attributes
        @zset = Tinto::SortedSet.new(self, User::Member, storage_key, members)
      end

      private

      def storage_key
        'users'
      end
    end # Collection
  end # User
end # Belinkr
