# encoding: utf-8
require 'Tinto/Context'

module Belinkr
  module AutoinviteToWorkspace
    class Context
      include Tinto::Context

      def initialize(arguments)
        @actor            = arguments.fetch(:actor)
        @enforcer         = arguments.fetch(:enforcer)
        @workspace        = arguments.fetch(:workspace)
        @autoinvitation   = arguments.fetch(:autoinvitation)
        @autoinvitations  = arguments.fetch(:autoinvitations)
        @tracker          = arguments.fetch(:tracker)
      end #initialize

      def call
        enforcer          .authorize(actor, :autoinvite, actor)
        autoinvitation    .link_to(
                            autoinvited:  actor,
                            workspace:    workspace
                          )
        autoinvitations   .add(autoinvitation)
        tracker           .register(workspace, actor, :autoinvited)

        will_sync autoinvitations, autoinvitation, tracker 
      end #call

      private

      attr_reader :actor, :enforcer, :workspace, :autoinvitation, 
                  :autoinvitations, :tracker
    end # Context
  end # AutoinviteToWorkspace
end # Belinkr

