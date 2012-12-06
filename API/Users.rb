# encoding: utf-8
require_relative '../API'

module Belinkr
  class API < Sinatra::Base
    get '/users' do
      dispatch :collection do
      end
    end # get /users

    get '/users/:user_id' do
    end # get /users/:user_id

    put '/users/:user_id' do
    end # put /users/:user_id

    delete '/users/:user_id' do
    end # delete /users/:user_id

    get '/users/:user_id/workspaces' do
    end # get /users/:user_id/workspaces

    get '/users/:user_id/followers' do
      dispatch :collection do
        Follower::Collection.new(
          user_id:    params.fetch('user_id'),
          entity_id:  current_entity.id
        ).page(params.fetch('page', 0))
      end
    end # get /users/:user_id/followers

    get '/users/:user_id/following' do
      dispatch :collection do
        Following::Collection.new(
          user_id:    params.fetch('user_id'),
          entity_id:  current_entity.id
        ).page(params.fetch('page', 0))
      end
    end # get /users/:user_id/following
  end # API
end # Belinkr

