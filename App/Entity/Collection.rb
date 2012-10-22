# encoding: utf-8
require 'forwardable'
require 'aequitas'
require_relative './Member'
require_relative '../../Tinto/Set'

module Belinkr
  module Entity
    class Collection
      extend Forwardable
      include Aequitas

      MODEL_NAME  = 'entity'

      def_delegators :@set, *Tinto::Set::INTERFACE

      def initialize
        @set = Tinto::Set.new self
      end

      def instantiate_member(attributes={})
        Member.new attributes
      end

      def storage_key
        'entities'
      end
    end # Collection
  end # Entity
end # Belinkr

