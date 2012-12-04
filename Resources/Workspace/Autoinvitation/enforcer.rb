# encoding: utf-8
require 'Tinto/Exceptions'

module Belinkr
  module Workspace
    module Autoinvitation
      class Enforcer
        include Tinto::Exceptions

        def initialize(workspace, autoinvitation,
          tracker=Workspace::Tracker.new)
          @workspace      = workspace
          @autoinvitation = autoinvitation
          @tracker        = tracker
        end #initialize

        def authorize(actor, action, *args)
          send action, actor, *args
        end #authorize

        def autoinvite(autoinvited, *args)
          relationship = tracker.relationship_for(workspace, autoinvited)
          raise NotAllowed if is_in?(autoinvited)
          raise NotAllowed if relationship == 'invited'
          raise NotAllowed if relationship == 'autoinvited'
          true
        end

        def accept(actor, autoinvited)
          raise NotAllowed unless is_in?(actor)
          raise NotAllowed if is_in?(autoinvited)
          true
        end

        def reject(actor, autoinvited)
          raise NotAllowed unless is_in?(actor)
          raise NotAllowed if is_in?(autoinvited)
          true
        end

        private

        attr_reader :workspace, :autoinvitation, :tracker

        def is_in?(user)
          relationship = tracker.relationship_for(workspace, user)
          relationship == 'collaborator' || relationship == 'administrator'
        end #is_in?
      end # Enforcer
    end # Autoinvitation
  end # Workspace
end # Belinkr

