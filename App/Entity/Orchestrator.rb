# encoding: utf-8
require_relative 'Collection'
require_relative '../../Tinto/Exceptions'

module Belinkr
  module Entity
    class Orchestrator
      def create(entity)
        entity.save
        entities.add entity
      end

      def update(entity, changes)
        entity.update(changes)
        entity
      end

      def delete(entity)
        entity.delete
        entity
      end

      def undelete(entity)
        entity.undelete
        entity
      end

      private

      def entities
        Belinkr::Entity::Collection.new
      end
    end # Orchestrator
  end # Entity
end # Belinkr
