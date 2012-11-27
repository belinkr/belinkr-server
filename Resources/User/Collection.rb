# encoding: utf-8
require 'forwardable'
require 'aequitas'
require_relative './Member'
require 'Tinto/Set'

module Belinkr
  module User
    class Collection
      extend Forwardable
      include Aequitas
      include Enumerable

      MODEL_NAME  = 'user'

      def_delegators :@set, *Tinto::Set::INTERFACE

      def initialize
        @set = Tinto::Set.new self
      end

      def instantiate_members(attributes={})
        Member.new attributes
      end

      def storage_key
        'users'
      end
    end # Collection
  end # User
end # Belinkr

