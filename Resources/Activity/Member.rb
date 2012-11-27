# encoding: utf-8
require 'forwardable'
require 'virtus'
require 'aequitas'
require_relative '../../Config'
require 'Tinto/Member'
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
      attribute :entity_id,       String
      attribute :actor,           Polymorphic
      attribute :action,          String
      attribute :object,          Polymorphic
      attribute :target,          Polymorphic
      attribute :clue,            Polymorphic
      attribute :description,     String
      attribute :created_at,      Time
      attribute :updated_at,      Time
      attribute :deleted_at,      Time


      validates_presence_of       :id, :entity_id, :actor, :action, :object
      validates_within            :action, set: ACTIONS
      validates_length_of         :description, max: 250

      def_delegators :@member,    *Tinto::Member::INTERFACE

      def initialize(attrs={})
        super attrs
        @member = Tinto::Member.new self
      end

      def storage_key
        "entities:#{entity_id}:activities"
      end
    end # Member
  end # Activity
end # Belinkr

