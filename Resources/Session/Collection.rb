# encoding: utf-8
require 'forwardable'
require 'aequitas'
require 'Tinto/Set'
require_relative './Member'

module Belinkr
  module Session
    class Collection
      extend Forwardable
      include Aequitas
      include Enumerable

      def_delegators :@set, *Tinto::Set::INTERFACE

      def initialize
        @set = Tinto::Set.new self
      end #initialize

      def instantiate_member(attributes={})
        Member.new attributes
      end #instantiate_member

      def storage_key
        'sessions'
      end #storage_key
    end # Collection
  end # Session
end # Belinkr

