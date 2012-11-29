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
          raise NotAllowed unless is_in?(actor)
          raise NotAllowed if is_in?(invited)
          raise NotAllowed if tracker.is?(workspace, invited, :invited)
          raise NotAllowed if tracker.is?(workspace, invited, :autoinvited)
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
          tracker.is?(workspace, user, :collaborator) ||
          tracker.is?(workspace, user, :administrator)
        end
        #  validation_error "validation.errors.already_in_workspace" if 
        #  validation_error "validation.errors.already_requested" if 
        #  validation_error "validation.errors.already_invited" if 
        #def validation_error(message_key)
        #  violation = Aequitas::Violation.new @autoinvitation, 
        #                                      I18n::t(message_key)
        #  @autoinvitation.errors[:invited_id] << violation
        #  raise InvalidResource 
        #end
      end # Enforcer
    end # Invitation
  end # Workspace
end # Belinkr

