# encoding: utf-8
require_relative '../API'
require_relative '../Resources/User/Presenter'

require_relative '../Cases/GetCollection/Request'
require_relative '../Cases/GetCollection/Context'

require_relative '../Cases/GetMember/Request'
require_relative '../Cases/GetMember/Context'

require_relative '../Cases/EditUserProfile/Request'
require_relative '../Cases/EditUserProfile/Context'

require_relative '../Cases/RemoveProfileFromEntity/Request'
require_relative '../Cases/RemoveProfileFromEntity/Context'

require_relative '../Cases/GetUserStatistics/Request'
require_relative '../Cases/GetUserStatistics/Context'
module Belinkr
  class API < Sinatra::Base
    get '/users' do
      dispatch :collection do
        data = GetCollection::Request.new(request_data.merge(type: :profile))
                .prepare
        GetCollection::Context.new(data).run
        data.fetch(:collection)
      end
    end # get /users

    get '/users/:user_id' do
      dispatch :read do
        data = GetMember::Request.new(request_data.merge(type: :user)).prepare

        GetMember::Context.new(data).run
        data.fetch(:member)
      end
    end # get /users/:user_id

    put '/users/:user_id' do
      dispatch :update, current_user do
        req_data  = request_data.merge(actor_profile: current_profile)
        data = EditUserProfile::Request.new(req_data).prepare
        EditUserProfile::Context.new(data).run
        data.fetch(:user)
      end
    end # put /users/:user_id

    delete '/users/:user_id' do
      dispatch :delete do
        req_data = request_data.merge(actor_profile: current_profile)
        data = RemoveProfileFromEntity::Request.new(req_data).prepare
        RemoveProfileFromEntity::Context.new(data).run
        data.fetch(:profile)
      end
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

    get '/users/:user_id/statistics' do
      dispatch :read do
        data = GetUserStatistics::Request.new(request_data).prepare

        GetUserStatistics::Context.new(data).run
        data.fetch(:user)
      end
    end
  end # API
end # Belinkr
