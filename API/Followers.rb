# encoding: utf-8
require_relative '../API'
require_relative '../Resources/User/Presenter'

require_relative '../Cases/FollowUserInEntity/Context'
require_relative '../Cases/FollowUserInEntity/Request'

require_relative '../Cases/UnfollowUserInEntity/Context'
require_relative '../Cases/UnfollowUserInEntity/Request'

module Belinkr
  class API < Sinatra::Base
    get '/followers' do
      dispatch :collection do
        Follower::Collection.new(
          user_id:    current_user.id,
          entity_id:  current_entity.id
        ).page(params.fetch('page', 0))
      end
    end # get /followers

    get '/following' do
      dispatch :collection do
        Following::Collection.new(
          user_id:    current_user.id,
          entity_id:  current_entity.id
        ).page(params.fetch('page', 0))
      end
    end # get /following

    post '/following/:followed_id' do
      data      = FollowUserInEntity::Request.new(
                    request_data.merge(actor_profile: current_profile)
                  ).prepare
      followed  = data.fetch(:followed)

      dispatch :create, followed do
        FollowUserInEntity::Context.new(data).run
        followed
      end
    end # post /following/:followed_id

    delete '/following/:followed_id' do
      data      = UnfollowUserInEntity::Request.new(
                    request_data.merge(actor_profile: current_profile)
                  ).prepare
      followed = data.fetch(:followed)

      dispatch :delete, followed do
        UnfollowUserInEntity::Context.new(data).run
        followed
      end
    end # delete /following/:followed_id
  end # API
end # Belinkr

