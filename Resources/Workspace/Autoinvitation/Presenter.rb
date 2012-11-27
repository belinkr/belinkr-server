# encoding: utf-8
require 'json'
require_relative '../../user/member'
require_relative '../../user/presenter'
require_relative '../../workspace/member'
require_relative '../../workspace/presenter'
require_relative '../../../tinto/utils'

module Belinkr
  module Workspace
    module Autoinvitation
      class Presenter
        def initialize(resource, actor=nil)
          @resource = resource
          @actor    = actor
        end

        def as_json
          as_poro.to_json
        end

        def as_poro
          {
            id:                 @resource.id,
            workspace_id:       @resource.workspace_id,
            entity_id:          @resource.entity_id,
            invited_id:         @resource.invited_id,
            invited_name:       name_for(@resource.invited_id),
            state:              @resource.state,
            rejected_at:        @resource.rejected_at
          }.merge! links
           .merge! Tinto::Presenter.timestamps_for(@resource)
           .merge! Tinto::Presenter.errors_for(@resource)
           .merge! workspace_info(@resource.workspace_id)
        end

        private

        def name_for(user_id)
          user = User::Member.new(id: user_id, entity_id: @actor.entity_id)
          User::Presenter.new(user, @actor).name_for(user)
        end

        def avatar_for(user_id)
          user = User::Member.new(id: user_id, entity_id: @actor.entity_id)
          user.avatar
        end

        def workspace_info(workspace_id)
          workspace = Workspace::Member
            .new(id: workspace_id, entity_id: @actor.entity_id)
          poro = Workspace::Presenter.new(workspace, @actor).as_poro
          { workspace_name: poro[:name], relationship: poro[:relationship] }
        end

        def links
          workspace_path = "/workspaces/#{@resource.workspace_id}"
          base_path       = "#{workspace_path}/autoinvitations"
          {
            links: {
              self:           "#{base_path}/#{@resource.id}",
              invited:        "/users/#{@resource.invited_id}",
              avatar:         avatar_for(@resource.invited_id),
              workspace:      workspace_path
            }
          }
        end
      end # Presenter
    end # Autoinvitation
  end # Workspace
end # Belinkr
