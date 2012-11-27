# encoding: utf-8
require 'json'
require_relative 'util'
require_relative 'invitation/tracker'
require_relative 'status/collection'
require_relative '../user/role/orchestrator'
require_relative '../../tinto/utils'

module Belinkr
  module Workspace
    class Presenter
      include Util 

      def initialize(resource, actor=nil)
        @resource = resource
        @actor    = actor
      end

      def as_json
        as_poro.to_json
      end

      def as_poro
        {
          id:             @resource.id,
          name:           @resource.name,
          entity_id:      @resource.entity_id,
        }.merge! relationship
         .merge! counters
         .merge! Tinto::Presenter.timestamps_for(@resource)
         .merge! Tinto::Presenter.errors_for(@resource)
         .merge! links
      end

      private

      def links
        base_path = "/workspaces"
        links = {
          self: "#{base_path}/#{@resource.id}",
        }.merge! invitation_link

        { links: links }
      end

      def invitation_link
        invitations = tracker_for(@resource).invitations_for(@actor)
        return {} unless invitations && !invitations.empty?
        invitation = invitations.first
        return { 
          invitation: "/workspaces/#{@resource.id}/invitations/#{invitation.id}",
          invitation_accept: "/workspaces/#{@resource.id}/invitations/accepted/#{invitation.id}",
          invitation_reject: "/workspaces/#{@resource.id}/invitations/rejected/#{invitation.id}"
        }
      end

      def counters
        return {} unless @resource.id
        {
          statuses_count: statuses_count,
          people_count:   people_count
        }
      end

      def statuses_count
        Workspace::Status::Collection.new(
          kind:         :general,
          workspace_id: @resource.id,
          entity_id:    @resource.entity_id
        ).size
      end

      def people_count
        administrators_for(@resource).size + collaborators_for(@resource).size
      end

      def relationship(actor = @actor)
        return  {} unless actor
        return  { relationship: 'administrator'
                } if User::Role::Orchestrator.is_entity_admin?(@actor)

        return  { relationship: 'collaborator'
                } if memberships_for(actor, :collaborator).include?(@resource)

        return  { relationship: 'administrator'
                } if memberships_for(actor, :administrator).include?(@resource)

        return  { relationship: 'invited'
                } if memberships_for(actor, :invited).include?(@resource)

        return  { relationship: 'autoinvited'
                } if memberships_for(actor, :autoinvited).include?(@resource)

        return  { relationship: 'none' }
      end

      def tracker_for(workspace)
        Invitation::Tracker
            .new(workspace_id: workspace.id, entity_id: workspace.entity_id)
      end
    end # Presenter
  end # Workspace
end # Belinkr
