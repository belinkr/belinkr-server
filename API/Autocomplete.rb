# encoding: utf-8
require_relative '../API'
require_relative '../Resources/User/Member'
require_relative '../Services/Searcher'
require_relative '../Services/Searcher/RedisBackend'
require_relative '../Services/Searcher/ESBackend'
require_relative '../Cases/AutocompleteUser/Request'
require_relative '../Cases/AutocompleteWorkspace/Request'
require_relative '../Cases/AutocompleteScrapbook/Request'

module Belinkr
  class API < Sinatra::Base
    get '/autocomplete/users' do
      searcher = Searcher.new Searcher::ESBackend.new "users"
      request = AutocompleteUser::Request.new(params, searcher, 'users')

      dispatch :collection do
        request.prepare.fetch(:users)
      end
    end

    get '/autocomplete/workspaces' do
      searcher = Searcher.new Searcher::ESBackend.new "workspaces"
      # for ES backend
      request = AutocompleteWorkspace::Request.new(
        params, current_session.entity_id, searcher, "workspaces")
      # for Redis Backend
      #request = AutocompleteWorkspace::Request.new(
      #  params, searcher, "entities:#{current_entity.id}:workspaces")

      dispatch :collection do
        request.prepare.fetch(:workspaces)
      end

    end

    get '/autocomplete/scrapbooks' do
      searcher = Searcher.new Searcher::ESBackend.new "scrapbooks"
      # for Redis Backend
      #request = AutocompleteScrapbook::Request.new(
      #  params, searcher, "users:#{current_user.id}:scrapbooks")

      # for ES Backend
      request = AutocompleteScrapbook::Request.new(
        params, current_user.id, searcher, "scrapbooks")
      dispatch :collection do
        request.prepare.fetch(:scrapbooks)
      end

    end
  end
end

