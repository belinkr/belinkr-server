# encoding: utf-8
require_relative '../API'
require_relative '../Resources/User/Member'
require_relative '../Services/Searcher'
require_relative '../Services/Searcher/RedisBackend'
require_relative '../Cases/AutocompleteUser/Request'

module Belinkr
  class API < Sinatra::Base
    get '/autocomplete/users' do
      searcher = Searcher.new Searcher::RedisBackend.new "users"
      request = AutocompleteUser::Request.new(params, searcher, 'users')

      dispatch :collection do
        request.prepare.fetch(:users)
      end
    end
  end
end

