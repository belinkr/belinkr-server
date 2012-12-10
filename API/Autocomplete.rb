# encoding: utf-8
require_relative '../API'
require_relative '../Resources/User/Member'
require_relative '../Services/Searcher'
require_relative '../Services/Searcher/RedisBackend'
require_relative '../Cases/AutocompleteUser/Request'
require_relative '../Cases/AutocompleteWorkspace/Request'
require_relative '../Cases/AutocompleteScrapbook/Request'

module Belinkr
  class API < Sinatra::Base
    get '/autocomplete/users' do
      searcher = Searcher.new Searcher::RedisBackend.new "users"
      request = AutocompleteUser::Request.new(params, searcher, 'users')

      dispatch :collection do
        request.prepare.fetch(:users)
      end
    end

    get '/autocomplete/workspaces' do
      searcher = Searcher.new Searcher::RedisBackend.new "workspaces"
      request = AutocompleteWorkspace::Request.new(
        params, searcher, "entities:#{current_entity.id}:workspaces")

      dispatch :collection do
        request.prepare.fetch(:workspaces)
      end

    end

    get '/autocomplete/scrapbooks' do
      searcher = Searcher.new Searcher::RedisBackend.new "scrapbooks"
      request = AutocompleteScrapbook::Request.new(
        params, searcher, "users:#{current_user.id}:scrapbooks")

      dispatch :collection do
        request.prepare.fetch(:scrapbooks)
      end

    end
  end
end

