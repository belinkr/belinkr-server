# encoding: utf-8
require 'json'
require 'Tinto/Presenter'

module Belinkr
  module Session
    class Presenter
      BASE_PATH = '/sessions'

      def initialize(resource, actor=nil)
        @resource = resource
        @actor    = actor
      end #initialize

      def as_json
        as_poro.to_json
      end #as_json

      def as_poro
        {
          id:         @resource.id,
          user_id:    @resource.user_id,
          profile_id: @resource.profile_id,
          entity_id:  @resource.entity_id
        }.merge! Tinto::Presenter.timestamps_for(@resource)
         .merge! Tinto::Presenter.errors_for(@resource)
      end #as_poro
    end # Presenter
  end # Session
end # Belinkr
