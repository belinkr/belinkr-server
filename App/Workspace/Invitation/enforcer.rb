# encoding: utf-8
require_relative '../../../tinto/exceptions'
require_relative '../../user/role/orchestrator'
require_relative '../util'

module Belinkr
  module Workspace
    module Invitation
      class Enforcer
        include Util
        include Tinto::Exceptions

        def self.authorize(user, action, workspace, invitation, invited=nil)
          if invited
            new(workspace, invitation).send :"#{action}_by?", user, invited
          else
            new(workspace, invitation).send :"#{action}_by?", user
          end
        end

        def initialize(workspace, invitation)
          @workspace  = workspace
          @invitation = invitation
        end

        def read_by?(user)
          raise NotAllowed if     @workspace.deleted_at
          raise NotAllowed unless is_in?(@workspace, user) ||
                                  user.id == @invitation.invited_id
        end

        def collection_by?(user)
          return if User::Role::Orchestrator.is_entity_admin?(user)
          raise NotAllowed unless is_in?(@workspace, user)
        end

        def invite_by?(inviter, invited)
          raise NotAllowed if     @workspace.deleted_at
          return if User::Role::Orchestrator.is_entity_admin?(inviter)
          raise NotAllowed unless is_in?(@workspace, inviter)
          raise NotAllowed unless @invitation.inviter_id == inviter.id

          validation_error 'validation.errors.already_in_workspace' if 
            is_in?(@workspace, invited)

          #validation_error 'validation.errors.already_invited' if already_invited?
        end

        def accept_by?(invited)
          raise NotAllowed if     @workspace.deleted_at
          raise NotAllowed unless @invitation.invited_id == invited.id
        end

        def delete_by?(inviter)
          raise NotAllowed if     @workspace.deleted_at
          raise NotAllowed unless is_in?(@workspace, inviter)
          raise NotAllowed unless @invitation.inviter_id == inviter.id
        end

        alias_method :reject_by?, :accept_by?

        private

        def already_invited?
          Invitation::Collection
            .new(workspace_id: @workspace.id, entity_id: @workspace.entity_id)
            .include?(@invitation)
        end

        def validation_error(message_key)
          violation = Aequitas::Violation.new @invitation, I18n::t(message_key)
          @invitation.errors[:invited_id] << violation
          raise InvalidResource 
        end
      end # Enforcer
    end # Invitation
  end # Workspace
end # Belinkr
