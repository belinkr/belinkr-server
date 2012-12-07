# encoding: utf-8
require_relative '../API'
require_relative '../Resources/User/Member'
require_relative '../Services/Searcher'
require_relative '../Services/Searcher/RedisBackend'

module Belinkr
  class API < Sinatra::Base
    get '/autocomplete/users' do
      dispatch :collection do
        searcher = Searcher.new Searcher::RedisBackend.new "users"
        results = searcher.autocomplete 'users', params.fetch('q')
        list = []
        results.each_pair do |redis_key,user_hash|
          list.push User::Member.new user_hash
        end
        list
      end
    end
  end
end

