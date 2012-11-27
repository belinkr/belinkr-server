# encoding: utf-8
require 'json'
require 'Tinto/Presenter'
#require_relative '../follower/collection'
#require_relative '../following/collection'
#require_relative '../status/collection'

module Belinkr
  module Profile
    class Presenter
      BASE_PATH = '/users'

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
          avatar:     @resource.user.avatar,
          first:      @resource.user.first,
          last:       @resource.user.last,
          name:       @resource.user.name,
          name_order: @resource.user.name_order,
          locale:     @resource.user.locale,
          timezone:   @resource.user.timezone,
          mobile:     @resource.mobile,
          fax:        @resource.fax,
          landline:   @resource.landline,
          #jid:       @resource.jid,
          position:   @resource.position,
          department: @resource.department
        }.merge! Tinto::Presenter.timestamps_for(@resource)
         .merge! Tinto::Presenter.errors_for(@resource)
         .merge! links
         #.merge! relationship(@resource, @actor)
         #.merge! counters_for(@resource)
      end #as_poro

      private

      #def counters_for(user)
      #  { counters: {
      #      followers:  followers_for(user).size, 
      #      following:  following_for(user).size,
      #      statuses:   own_statuses_for(user).size
      #    }
      #  }
      #end

      def links
        user_base_path = "#{BASE_PATH}/#{@resource.id}"
        {
          links: {
            self:       user_base_path,
            avatar:     @resource.user.avatar,
            timeline:   "#{user_base_path}/statuses",
            followers:  "#{user_base_path}/followers",
            following:  "#{user_base_path}/following",
            workspaces: "#{user_base_path}/workspaces"
          }
        }
      end

      def relationship(user, actor)
        return {} unless actor
        return { relationship: 'follower'   } if follower?(user, actor)
        return { relationship: 'following'  } if following?(user, actor)
        return { relationship: 'self'       } if user.id == actor.id
        return { relationship: 'none'       }
      end

      #def followers_for(user)
      #  Follower::Collection.new(user_id: user.id, entity_id: user.entity_id)
      #end

      #def following_for(user)
      #  Following::Collection.new(user_id: user.id, entity_id: user.entity_id)
      #end

      #def own_statuses_for(user)
      #  Status::Collection.new(
      #    user_id:    user.id,
      #    entity_id:  user.entity_id,
      #    kind:       'own'
      #  )
      #end

      def follower?(user, actor)
        followers_for(user).include?(actor)
      end

      def following?(user, actor)
        following_for(user).include?(actor)
      end
    end # Presenter
  end # Profile
end # Belinkr
