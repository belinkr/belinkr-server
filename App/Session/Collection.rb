# encoding: utf-8
require 'forwardable'
require 'aequitas'
require_relative './Member'
require_relative '../../Tinto/Set'

module Belinkr
  module Session
    class Collection
      extend Forwardable
      include Aequitas
      include Enumerable

      def_delegators :@set, *Tinto::Set::INTERFACE

      def initialize
        @set = Tinto::Set.new self
      end

      def instantiate_member(attributes={})
        Member.new attributes
      end

      def storage_key
        'sessions'
      end
    end # Collection
  end # Session
end # Belinkr

