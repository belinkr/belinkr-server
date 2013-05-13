# encoding: utf-8
require_relative '../../Resources/User/Member'
require_relative '../../Resources/User/Enforcer'
require_relative '../../Resources/Following/Collection'
require_relative '../../Resources/Follower/Collection'
require_relative '../../Resources/Status/Collection'

module Belinkr
  module GetUserStatistics
    class Request
      def initialize(arguments)
        @payload    = arguments.fetch(:payload)
        @actor      = arguments.fetch(:actor)
        @entity     = arguments.fetch(:entity)
      end #initialize

      def prepare
        {
          enforcer:   enforcer,
          actor:      actor,
          user:       user
        }
      end #prepare

      private

      attr_reader :payload, :actor, :entity

      def user
        @user ||= User::Member.new(
          id:     payload.fetch('user_id'),
        ).fetch
        raise Tinto::Exceptions::NotFound if @user.deleted_at

        add_statistics if @user

        @user
      end #user

      def add_statistics
        @user.statistics = {
          following: Following::Collection.new(
                           user_id:    @user.id,
                           entity_id:  entity.id
                         ),
          followers: Follower::Collection.new(
                           user_id:    @user.id,
                           entity_id:  entity.id
                         ),
          statuses_count: Status::Collection.new(
                            :kind => 'own',
                            :scope => @user).length

        }
      end

      def enforcer
        User::Enforcer.new(user)
      end

    end # Request
  end # GetStatus
end # Belinkr

