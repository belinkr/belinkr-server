# encoding: utf-8
require 'forwardable'
require 'virtus'
require 'aequitas'
require_relative './Member'
require 'Tinto/SortedSet'

module Belinkr
  module Status
    class Collection
      extend Forwardable
      include Virtus
      include Aequitas
      include Enumerable

      MODEL_NAME  = 'status'
      KINDS       = %w{ own general replies files workspaces
                        forwarded_by_you forwarded_by_others }

      attribute :kind,              String
      attribute :context,           Polymorphic

      validates_presence_of         :kind, :context
      validates_within              :kind, set: KINDS

      def_delegators :@zset,        *Tinto::SortedSet::INTERFACE

      def initialize(attributes={})
        super attributes
        @zset = Tinto::SortedSet.new self
      end

      def instantiate_member(attributes={})
        Member.new attributes.merge!(context: context)
      end

      def storage_key
        return unless context
        "#{context.storage_key}:#{context.id}:timelines:#{kind}"
      end
    end # Collection
  end # Status
end # Belinkr
