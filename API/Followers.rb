# encoding: utf-8
require_relative '../api'
require_relative '../app/follower/orchestrator'
require_relative '../app/follower/collection'
require_relative '../app/following/collection'
require_relative '../app/user/presenter'

module Belinkr
  class API < Sinatra::Base
    get '/followers' do
      dispatch :collection do
        Follower::Collection.new(
          user_id:    current_user.id,
          entity_id:  current_user.entity_id,
        ).page(params[:page])
      end
    end # get /followers

    get '/following' do
      dispatch :collection do
        Following::Collection.new(
          user_id:    current_user.id,
          entity_id:  current_user.entity_id,
        ).page(params[:page])
      end
    end # get /following

    get '/users/:id/followers' do
      dispatch :collection do
        user = User::Member
          .new(id: params[:id], entity_id: current_user.entity_id)

        Follower::Collection
          .new(user_id: user.id, entity_id: user.entity_id)
          .page(params[:page])
      end
    end # get /users/:id/followers

    get '/users/:id/following' do
      dispatch :collection do
        user = User::Member
          .new(id: params[:id], entity_id: current_user.entity_id)

        Following::Collection
          .new( user_id: user.id, entity_id: user.entity_id)
          .page(params[:page])
      end
    end # get /users/:id/following

    post '/users/:id/followers' do
      followed = User::Member
        .new(id: params[:id], entity_id: current_user.entity_id)

      dispatch :create, followed do
        Follower::Orchestrator.new(current_user).create(followed)
      end
    end # post /users/:id/followers

    delete '/users/:id/followers/:follower_id' do
      followed = User::Member
        .new(id: params[:id], entity_id: current_user.entity_id)

      dispatch :delete, followed do
        Follower::Orchestrator.new(current_user).delete(followed)
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
