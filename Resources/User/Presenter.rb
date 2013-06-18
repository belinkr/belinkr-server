# encoding: utf-8
require 'json'
require 'ostruct'
require 'Tinto/Presenter'
require_relative '../Status/Collection'
require_relative '../Following/Collection'
require_relative '../Following/Collection'

module Belinkr
  module User
    class Presenter
      def initialize(user, scope={})
        @user   = user
        @entity = scope.fetch(:entity)
      end #initialize

      def as_json(*args)
        as_poro.to_json(*args)
      end #as_json

      def as_poro
        {
          id:         user.id,
          avatar:     user.avatar,
          name:       user.name,
          first:      user.first,
          last:       user.last,
          jid:        profile ? profile.jid : nil,
          mobile:     profile ? profile.mobile : nil,
          landline:   profile ? profile.landline : nil,
          fax:        profile ? profile.fax : nil,
          position:   profile ? profile.position : nil,
          department: profile ? profile.department : nil,
          statistics: statistics
        }
          .merge! Tinto::Presenter.timestamps_for(user)
          .merge! Tinto::Presenter.errors_for(user)
      end #as_poro

      private

      attr_reader :user, :entity

      def statistics
        {
          following: following_count,
          followers: follower_count,
          statuses: status_count
        }
      end

      def following_count
        Following::Collection.new(user_id: user.id, entity_id: entity.id).size
      end

      def follower_count
        Follower::Collection.new(user_id: user.id, entity_id: entity.id).size
      end

      def status_count
        Status::Collection.new(
          user_id: user.id, entity_id: entity.id, kind: 'own', scope: user).size
      end

      def profile
        profile_in_same_entity = user.profile_for(entity)
        if profile_in_same_entity
          @profile ||= profile_in_same_entity.fetch
        end
      end #profile

    end # Presenter
  end # User
end # Belinkr

