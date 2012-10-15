# encoding: utf-8
require_relative '../API'
require_relative '../App/Reset/Member'
require_relative '../App/Reset/Presenter'
require_relative '../App/User/Locator'
require_relative '../App/Contexts/RequestPasswordReset'
require_relative '../App/Contexts/ResetPassword'

module Belinkr
  class API < Sinatra::Base
    post '/resets' do
      begin
        email = payload.fetch('email')
        user  = User::Locator.user_from(email)
        reset = Reset::Member.new
        RequestPasswordReset.new(user, reset).call
      rescue Tinto::Exceptions::NotFound
      ensure return 201
      end
    end # post /resets

    get '/resets/:id' do
      dispatch :read do
        Reset::Member.new(id: params[:id])
        return 200
      end
    end # get /resets/:id

    put '/resets/:id' do
      reset         = Reset::Member.new(id: params[:id])
      user          = User::Locator.user_from(reset.email)
      user_changes  = User::Member.new(password: payload.fetch('password'))

      dispatch :update, reset do
        ResetPassword.new(user, reset, user_changes).call
        return 200
      end
    end # put /resets/:id
  end # API
end # Belinkr
