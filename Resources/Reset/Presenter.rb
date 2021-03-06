# encoding: utf-8
require 'json'
require 'Tinto/Presenter'

module Belinkr
  module Reset
    class Presenter
      BASE_PATH = '/resets'

      def initialize(resource, scope={})
        @resource = resource
      end #initialize

      def as_json(*args)
        as_poro.to_json(*args)
      end #as_json

      def as_poro
        {
          id:       @resource.id,
          email:    @resource.email,
          user_id:  @resource.user_id
        }.merge! Tinto::Presenter.timestamps_for(@resource)
         .merge! Tinto::Presenter.errors_for(@resource)
      end #as_poro
    end # Presenter
  end # Reset
end # Belinkr

