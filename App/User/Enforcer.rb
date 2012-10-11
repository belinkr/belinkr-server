# encoding: utf-8
require_relative '../../Tinto/Exceptions'

module Belinkr
  module User
    class Enforcer
      include Tinto::Exceptions

      def self.authorize(actor, entity_id, action, resource)
        new(resource, entity_id).send :"#{action}_by?", actor
      end

      def initialize(resource, entity_id)
        @resource   = resource
        @entity_id  = entity_id
      end

      def create_by?(actor)
        ensure_same_entity_as(actor)
      end

      def read_by?(actor)
        raise NotFound if @resource.deleted_at
        ensure_same_entity_as(actor)
      end

      def collection_by?(actor)
        ensure_same_entity_as(actor)
      end

      def update_by?(actor)
        ensure_same_entity_as(actor)
        raise NotAllowed unless @resource.id == actor.id
      end

      alias_method :delete_by?, :update_by?
      alias_method :undelete_by?, :update_by?

      private

      def ensure_same_entity_as(actor)
        #raise NotAllowed unless @resource.entity_ids.include?(@entity_id)
      end
    end # Enforcer
  end # User
end # Belinkr
