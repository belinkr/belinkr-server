# encoding: utf-8
require 'json'
require 'Tinto/Presenter'

module Belinkr
  module User
    class Presenter
      def initialize(user, actor=nil, actor_profile=nil)
        @user   = user
        @actor  = actor
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
          #mobile:     user.profile.mobile
        }
          .merge! Tinto::Presenter.timestamps_for(user)
          .merge! Tinto::Presenter.errors_for(user)
      end #as_poro

      private
      
      attr_reader :user, :actor
    end # Presenter
  end # User
end # Belinkr

