# encoding: utf-8
require 'json'
require 'forwardable'
require 'virtus'
require 'aequitas'
require_relative '../../Config'
require_relative '../../Tinto/Member'
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
                    
      attribute :id,              Integer
      attribute :entity_id,       Integer
      attribute :actor,           Polymorphic
      attribute :action,          String
      attribute :object,          Polymorphic
      attribute :target,          Polymorphic
      attribute :clue,            Polymorphic
      attribute :description,     String
      attribute :created_at,      Time
      attribute :updated_at,      Time
      attribute :deleted_at,      Time


      validates_presence_of       :entity_id, :actor, :action, :object
      validates_numericalness_of  :entity_id
      validates_within            :action, set: ACTIONS
      validates_length_of         :description, max: 250

      def_delegators :@member,    :==, :score, :read, :save, :update, :to_json,
                                  :delete, :undelete 

      alias_method :to_hash, :attributes

      def initialize(attrs={}, retrieve=true)
        super attrs
        @member = Tinto::Member.new self, retrieve
      end

      def storage_key
        "entities:#{entity_id}:activities"
      end
    end # Member
  end # Activity
end # Belinkr
