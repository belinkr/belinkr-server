# encoding: utf-8
require_relative '../../Tinto/Context'

module Belinkr
  module AutoinviteToWorkspace
    class Context
      include Tinto::Context

      def initialize(arguments)
        @actor                      = arguments.fetch(:actor)
        @enforcer                   = arguments.fetch(:enforcer)
        @workspace                  = arguments.fetch(:workspace)
        @autoinvitation             = arguments.fetch(:autoinvitation)
        @autoinvitations            = arguments.fetch(:autoinvitations)
        @tracker                    = arguments.fetch(:tracker)
        @memberships_as_autoinvited = arguments
                                        .fetch(:memberships_as_autoinvited)
      end #initialize

      def call
        enforcer                    .authorize(actor, :autoinvite)
        autoinvitation              .link_to(
                                      autoinvited:  actor,
                                      workspace:    workspace
                                    )
        autoinvitations             .add(autoinvitation)
        tracker                     .add(:autoinvited, actor.id)
        memberships_as_autoinvited  .add(workspace)

        will_sync autoinvitations, autoinvitation, tracker, 
                  memberships_as_autoinvited
      end #call

      private

      attr_reader :actor, :enforcer, :workspace, :autoinvitation, 
                  :autoinvitations, :tracker, :memberships_as_autoinvited
    end # Context
  end # AutoinviteToWorkspace
end # Belinkr

