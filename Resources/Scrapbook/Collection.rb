# encoding: utf-8
require 'forwardable'
require 'virtus'
require 'aequitas'
require_relative 'Member'
require 'Tinto/Set'

module Belinkr
  module Scrapbook
    class Collection
      extend Forwardable
      include Virtus
      include Aequitas
      include Enumerable

      MODEL_NAME  = 'scrapbook'
      KINDS       = %w{ own others }

      attribute :user_id,         String
      attribute :kind,            String

      validates_presence_of       :user_id, :kind
      validates_within            :kind, set: KINDS

      def_delegators :@set,       *Tinto::Set::INTERFACE

      def initialize(attributes={})
        super attributes
        @set = Tinto::Set.new self
      end

      def instantiate_member(attributes={})
        Member.new attributes.merge(user_id: user_id)
      end

      def storage_key
        "users::#{user_id}:scrapbooks:#{kind}"
      end
    end # Collection
  end # Scrapbook
end # Belinkr

