#encoding: utf-8
require_relative '../../../tinto/exceptions'
require_relative '../../user/role/orchestrator'
require_relative '../util'

module Belinkr
  module Workspace
    module Autoinvitation
      class Enforcer
        include Tinto::Exceptions
        include Util

        def self.authorize(user, action, workspace, autoinvitation)
          new(workspace, autoinvitation).send(:"#{action}_by?", user)
        end

        def initialize(workspace, autoinvitation)
          @workspace      = workspace
          @autoinvitation = autoinvitation
        end
       
        private

        def read_by?(user)
          raise NotAllowed if     @workspace.deleted_at
          raise NotAllowed unless is_in?(@workspace, user) ||
                                  user.id == @autoinvitation.invited_id
        end

        def collection_by?(user)
          return if User::Role::Orchestrator.is_entity_admin?(user)
          raise NotAllowed unless is_in?(@workspace, user)
        end

        def request_by?(user)
          raise NotAllowed if     @workspace.deleted_at
          
          validation_error "validation.errors.already_in_workspace" if 
            is_in?(@workspace, user)

          validation_error "validation.errors.already_requested" if 
            already_requested?
        end
        
        def accept_by?(user)
          raise NotAllowed unless user.id
          raise NotAllowed unless @autoinvitation.entity_id    == user.entity_id
          raise NotAllowed unless @autoinvitation.workspace_id == @workspace.id
          return if User::Role::Orchestrator.is_entity_admin?(user)
          raise NotAllowed unless administrators_for(@workspace).include?(user)  
        end
      
        alias_method :reject_by?, :accept_by?
        alias_method :delete_by?, :accept_by?

        private

        def already_requested?
          Autoinvitation::Collection
            .new(workspace_id: @workspace.id, entity_id: @workspace.entity_id)
            .include?(@autoinvitation)
        end

        def validation_error(message_key)
          violation = Aequitas::Violation.new @autoinvitation, 
                                              I18n::t(message_key)
          @autoinvitation.errors[:invited_id] << violation
          raise InvalidResource 
        end
      end # Enforcer
    end # Autoinvitation
  end # Workspace
end # Belinkr
