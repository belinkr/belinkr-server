# encoding: utf-8
require 'json'
require 'ostruct'
require 'Tinto/Presenter'

module Belinkr
  module User
    class Presenter
      def initialize(user, scope={})
        @user   = user
        @entity = scope.fetch(:entity)
      end #initialize

      def as_json
        as_poro.to_json
      end #as_json

      def as_poro
        {
          id:         user.id,
          name:       user.name,
          first:      user.first,
          last:       user.last,
          mobile:     profile.mobile
        }
          .merge! Tinto::Presenter.timestamps_for(user)
          .merge! Tinto::Presenter.errors_for(user)
      end #as_poro

      private
      
      attr_reader :user, :entity

      def profile
        @profile ||= user.profile_for(entity).fetch
      end #profile
    end # Presenter
  end # User
end # Belinkr

