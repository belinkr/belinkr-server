# encoding: utf-8
require_relative '../API'
require_relative '../Resources/Reset/Presenter'
require_relative '../Cases/RequestPasswordReset/Context'
require_relative '../Cases/RequestPasswordReset/Request'
require_relative '../Cases/ResetPassword/Context'
require_relative '../Cases/ResetPassword/Request'

module Belinkr
  class API < Sinatra::Base
    post '/resets' do
      begin
        data = RequestPasswordReset::Request.new(payload: payload).prepare
        RequestPasswordReset::Context.new(data).run
      rescue Tinto::Exceptions::NotFound
      ensure return 201
      end
    end # post /resets

    get '/resets/:reset_id' do
      dispatch :read do
        reset = Reset::Member.new(id: params.fetch('reset_id'))
        begin
          reset.fetch
        rescue Tinto::Exceptions::NotFound
          return 200
        end
        reset
      end
    end # get /resets/:id

    put '/resets/:reset_id' do
      data  = ResetPassword::Request.new(payload: combined_input).prepare
      reset = data.fetch(:reset)

      dispatch :update, reset do
        ResetPassword::Context.new(data).run
        return 200
      end
    end # put /resets/:id
  end # API
end # Belinkr

