# encoding: utf-8
require_relative '../API'
require_relative '../App/Reset/Member'
require_relative '../App/Reset/Presenter'
require_relative '../App/User/Member'
require_relative '../App/User/Locator'
require_relative '../App/Contexts/RequestPasswordReset'
require_relative '../App/Contexts/ResetPassword'

module Belinkr
  class API < Sinatra::Base
    post '/resets' do
      data = RequestPasswordReset::Request.new(payload).prepare
      begin
        RequestPasswordReset::Context.new(data).run
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
      reset         = Reset::Member.new(id: params[:id]).fetch
      user          = User::Member.new(
                        id: User::Locator.new.id_for(reset.email)
                      ).fetch
      user_changes  = payload

      dispatch :update, reset do
        context = ResetPassword.new(user, user_changes, reset)
        context.call
        context.sync
        return 200
      end
    end # put /resets/:id
  end # API
end # Belinkr
