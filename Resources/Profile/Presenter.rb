# encoding: utf-8
require 'json'
require 'Tinto/Presenter'

module Belinkr
  module Profile
    class Presenter
      def initialize(profile, actor=nil)
        @profile  = profile
        @actor    = actor
      end #initialize

      def as_json
        as_poro.to_json
      end #as_json

      def as_poro
        {
          id:       user.id,
          first:    user.first,
          last:     user.last,
          name:     user.name,
          mobile:   profile.mobile
        }
          .merge! Tinto::Presenter.timestamps_for(profile)
          .merge! Tinto::Presenter.errors_for(profile)
      end #as_poro

      private
      
      attr_reader :profile, :actor

      def user
        @user ||= profile.user.fetch
      end #user
    end # Presenter
  end # Profile
end # Belinkr

