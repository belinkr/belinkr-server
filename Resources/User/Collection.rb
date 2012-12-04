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

      def initialize(storage_key=nil)
        @storage_key  = storage_key
        @set          = Tinto::Set.new self
      end #initialize

      def instantiate_member(attributes={})
        Member.new attributes
      end #instantiate_member

      def storage_key
        @storage_key || 'users'
      end #storage_key
    end # Collection
  end # User
end # Belinkr

