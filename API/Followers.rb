# encoding: utf-8
require_relative '../API'
require_relative '../App/Follower/Collection'
require_relative '../App/Following/Collection'
require_relative '../App/Profile/Presenter'
require_relative '../App/Contexts/FollowUserInEntity'
require_relative '../App/Contexts/UnfollowUserInEntity'

module Belinkr
  class API < Sinatra::Base
    get '/followers' do
      dispatch :collection do
        collection = Follower::Collection.new(
          profile_id: current_profile.id,
          entity_id:  current_entity.id
        ).page(params[:page])
        collection
      end
    end # get /followers

    get '/following' do
      dispatch :collection do
        Following::Collection.new(
          profile_id: current_profile.id,
          entity_id:  current_entity.id
        ).page(params[:page])
      end
    end # get /following

    get '/users/:id/followers' do
      dispatch :collection do 
        Follower::Collection
          .new(profile_id: params[:id], entity_id: current_entity.id)
          .page(params[:page])
      end
    end # get /users/:id/followers

    get '/users/:id/following' do
      dispatch :collection do
        Following::Collection
          .new(profile_id: params[:id], entity_id: current_entity.id)
          .page(params[:page])
      end
    end # get /users/:id/following

    post '/users/:id/followers' do
      followed = Profile::Member.new(id: params[:id], 
                      entity_id: current_entity.id).fetch
      options = {
        actor:      current_profile,
        followed:   followed,
        followers:  Follower::Collection.new(profile_id: params[:id],
                      entity_id: current_entity.id),
        following:  Following::Collection.new(profile_id: current_profile.id,
                      entity_id: current_entity.id),
        entity:     current_entity,
        actor_timeline:   Status::Collection.new(context: current_profile, 
                            kind: 'general'),
        latest_statuses:  Status::Collection.new(context: followed,
                            kind: 'own')
      }
      
      dispatch :create, followed do
        context = FollowUserInEntity.new(options)
        context.call
        context.sync
        options.fetch(:actor)
      end
    end # post /users/:id/followers

    delete '/users/:id/followers/:follower_id' do
      followed = Profile::Member.new(id: params[:id], 
                      entity_id: current_entity.id).fetch
      options = {
        actor:      current_profile,
        followed:   followed,
        followers:  Follower::Collection.new(profile_id: params[:id],
                      entity_id: current_entity.id),
        following:  Following::Collection.new(profile_id: current_profile.id,
                      entity_id: current_entity.id),
        entity:     current_entity,
      }
      
      dispatch :delete, followed do
        context = UnfollowUserInEntity.new(options)
        context.call
        context.sync
        options.fetch(:actor)
      end
    end # delete /users/:id/followers/:follower_id

    get '/counters' do
      followers = Follower::Collection
        .new(user_id: current_user.id, entity_id:  current_user.entity_id)
      following = Following::Collection
        .new(user_id: current_user.id, entity_id:  current_user.entity_id)
      statuses = Status::Collection.new(
        user_id:    current_user.id,
        entity_id:  current_user.entity_id,
        kind:       'own'
      )

      { 
        followers:  followers.size, 
        following:  following.size,
        statuses:   statuses.size
      }.to_json
    end
  end # API
end # Belinkr
