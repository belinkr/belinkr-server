# encoding: utf-8
require_relative '../Config'
require_relative '../App/User/Member'
require_relative '../App/User/Locator'
require_relative '../App/Session/Presenter'
require_relative '../App/Contexts/LogIntoEntity'
require_relative '../App/Contexts/LogOut'

module Belinkr
  class API < Sinatra::Base
    post '/sessions' do
      email     = payload['email']
      plaintext = payload['password']
      remember  = payload['remember']

      dispatch :create do
        user          = User::Member.new(id: User::Locator.new.id_for(email))
                          .fetch
        context       = LogIntoEntity.new(user, plaintext)
        auth_session  = context.call
        context.sync

        session['auth_token'] = auth_session.id

        response.set_cookie Config::AUTH_TOKEN_COOKIE, 
          value:    session['auth_token'], 
          path:     '/'

        response.set_cookie(Config::REMEMBER_COOKIE, 
          value:    session['auth_token'], 
          path:     '/',
          expires:  Time.now + Config::COOKIE_EXPIRATION_IN_SECS
        ) if remember

        auth_session
      end
    end # post /sessions

    delete '/sessions/:id' do
      dispatch :delete do
        auth_session = Session::Member.new(id: session['auth_token']).fetch
        LogOut.new(auth_session).call
        session[:auth_token] = nil

        if request.cookies[Config::AUTH_TOKEN_COOKIE]
          response.delete_cookie Config::AUTH_TOKEN_COOKIE, path: '/'
        end

        if request.cookies[Config::REMEMBER_COOKIE]
          response.delete_cookie Config::REMEMBER_COOKIE , path: '/'
        end

        auth_session
      end
    end # delete /sessions/:id
  end # API
end # Belinkr
