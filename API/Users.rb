# encoding: utf-8
require_relative '../API'
require_relative '../App/User/Member'
require_relative '../App/Profile/Member'
require_relative '../App/Profile/Collection'
require_relative '../App/Profile/Presenter'
require_relative '../App/Contexts/EditUserProfile'
require_relative '../App/Contexts/RemoveProfileFromEntity'

module Belinkr
  class API < Sinatra::Base
    get '/users' do
      dispatch :collection do
        collection = Profile::Collection.new(entity_id: current_entity.id)
          .page(params[:page])
        collection
      end
    end # get /users

    get '/users/:id' do
      dispatch :read do
        profile = Profile::Member.new(
                    id: params[:id], entity_id: current_entity.id
                  ).fetch
        raise Tinto::Exceptions::NotFound if profile.deleted_at
        profile
      end
    end # get /users/:id

    put '/users/:id' do
      profile = Profile::Member.new(
                  id: params[:id], entity_id: current_entity.id
                ).fetch
      user    = profile.user
      user.fetch
      changes = payload

      dispatch :update, profile do
        context = EditUserProfile
                    .new(current_user, user, changes, profile, changes)
        context.call
        context.sync
        profile
      end
    end # put /users/:id

    delete '/users/:id' do
      profile   = Profile::Member
                    .new(id: params[:id], entity_id: current_entity.id).fetch
      profiles  = Profile::Collection.new(entity_id: current_entity.id)
      user      = profile.user
      user.fetch

      dispatch :delete do
        context   = RemoveProfileFromEntity
          .new(current_user, user, profile, profiles, current_entity)
        context.call
        context.sync
        profile
      end
    end # delete /users/:id

    #get '/users/:id/summary' do
    #  dispatch :read do
    #    profile = Profile::Member
    #                .new(id: params[:id], entity_id: current_entity.id)
    #    ViewUserSummary.new(current_user, profile, current_entity).call
    #  end
    #end # get /users/:id/summary

    #get '/users/:id/workspaces' do
    #  user = User::Member
    #  .new(id: params[:id], entity_id: current_user.entity_id)
    #  dispatch :collection do
    #    Workspace::Orchestrator.new(current_user).collection(
    #      Workspace::Membership::Collection.new(
    #        kind:       :own,
    #        user_id:    user.id,
    #        entity_id:  user.entity_id
    #      )
    #      .page_size(params[:perPage])
    #      .page(params[:page])
    #    )
    #  end
    #end # get /users/:id/workspaces

    #fake searcher
    #get "/users/search" do
    #  name = params[:name]
    #  page = params[:page].to_i || 0
    #  perPage = params[:perPage].to_i || 20
    #  query = {name: name}
    #  retriever = User::Retriever.new(current_user, [], query, page, perPage)
    #  dispatch :collection do
    #    User::Orchestrator.new(current_user).collection(retriever.search_collection)
    #  end
    #end

    #fake searcher
    #get '/users/autocomplete' do
    #  #name = payload.delete("name")
    #  name = params[:name]
    #  page = params[:page].to_i || 0
    #  perPage = params[:perPage].to_i || 20
    #  query = {name: name}
    #  retriever = User::Retriever.new(current_user, [], query, page, perPage)
    #  retriever.search
    #  [200,retriever.results.to_json]
    #end

  end # API
end # Belinkr
