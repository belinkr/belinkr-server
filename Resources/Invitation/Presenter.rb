# encoding: utf-8
require 'json'
require 'Tinto/Presenter'

module Belinkr
  module Invitation
    class Presenter
      BASE_PATH = '/invitations'

      def initialize(resource, actor=nil)
        @resource = resource
      end #initialize

      def as_json
        as_poro.to_json
      end #as_json

      def as_poro
        {
          id:             @resource.id,
          entity_id:      @resource.entity_id,
          inviter_id:     @resource.inviter_id,
          invited_name:   @resource.invited_name,
          invited_email:  @resource.invited_email,
          locale:         @resource.locale,
          state:          @resource.state,
        }.merge! Tinto::Presenter.timestamps_for(@resource)
         .merge! Tinto::Presenter.errors_for(@resource)
         .merge! links
      end #as_poro

      private

      def links
        invitation_base_path = "#{BASE_PATH}/#{@resource.id}"
        {
            self:       invitation_base_path,
            inviter:    "/users/#{@resource.inviter_id}"
        }
      end #links
    end # Presenter
  end # Invitation
end # Belinkr
