# encoding: utf-8
require 'forwardable'
require 'virtus'
require 'aequitas'
require 'Tinto/Member'
require_relative '../../Config'
require_relative '../Polymorphic/Polymorphic'

module Belinkr
  module Activity
    class Member
      extend Forwardable
      include Virtus
      include Aequitas

      MODEL_NAME  = 'activity'
      ACTIONS     = Config::ACTIVITY_ACTIONS + 
                    Config::ACTIVITY_ACTIONS_EXTENSIONS
                    
      attribute :id,              String
      attribute :action,          String
      attribute :description,     String
      attribute :actor,           Polymorphic
      attribute :object,          Polymorphic
      attribute :target,          Polymorphic
      attribute :scope,           Polymorphic
      attribute :created_at,      Time
      attribute :updated_at,      Time
      attribute :deleted_at,      Time


      validates_presence_of       :entity_id, :actor, :action, :object, :scope
      validates_within            :action, set: ACTIONS
      validates_length_of         :description, max: 250

      def_delegators :@member,    *Tinto::Member::INTERFACE

      def initialize(attributes={})
        self.attributes = attributes
        @member         = Tinto::Member.new self
      end #initialize

      def storage_key
        "#{scope.storage_key}:activities"
      end #storage_key
    end # Member
  end # Activity
end # Belinkr

