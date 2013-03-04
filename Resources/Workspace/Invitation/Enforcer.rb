# encoding: utf-8
require 'Tinto/Exceptions'

module Belinkr
  module Workspace
    module Invitation
      class Enforcer
        include Tinto::Exceptions

        def initialize(workspace, invitation, tracker=Workspace::Tracker.new)
          @workspace  = workspace
          @invitation = invitation
          @tracker    = tracker
        end #initialize

        def authorize(actor, action, *args)
          send action, actor, *args
        end #authorize

        def invite(actor, invited)
          relationship = tracker.relationship_for(workspace, invited)
          raise NotAllowed unless is_in?(actor)
          raise NotAllowed if is_in?(invited)
          raise NotAllowed if relationship == 'invited'
          raise NotAllowed if relationship == 'autoinvited'
          true
        end

        def accept(actor, *args)
          raise NotAllowed if is_in?(actor)
          true
        end

        def reject(actor, *args)
          raise NotAllowed if is_in?(actor)
          true
        end

        private

        attr_reader :workspace, :invitation, :tracker

        def is_in?(user)
          relationship = tracker.relationship_for(workspace, user)
          relationship == 'collaborator' || relationship == 'administrator'
        end #is_in?

        #  validation_error "validation.errors.already_in_workspace" if
        #  validation_error "validation.errors.already_requested" if
        #  validation_error "validation.errors.already_invited" if

        def validation_error(message_key)
          violation = Aequitas::Violation
                      .new(@invitation, I18n::t(message_key))
          @invitation.errors[:invited_id] << violation
          raise InvalidResource
        end
      end # Enforcer
    end # Invitation
  end # Workspace
end # Belinkr

