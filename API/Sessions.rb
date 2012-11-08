# encoding: utf-8
require_relative '../API'
require_relative '../Config'
require_relative '../Data/Session/Presenter'
require_relative '../Cases/LogIn/Request'
require_relative '../Cases/LogIn/Context'
#require_relative '../App/Cases/LogOut/Request'
#require_relative '../App/Cases/LogOut/Context'

module Belinkr
  class API < Sinatra::Base
    post '/sessions' do
      data              = LogIn::Request.new(payload).prepare
      persisted_session = data.fetch(:session)

      dispatch :create do
        LogIn::Context.new(data).run
        session['auth_token'] = persisted_session.id

        response.set_cookie Config::AUTH_TOKEN_COOKIE, 
          value:    session['auth_token'], 
          path:     '/'

        response.set_cookie(Config::REMEMBER_COOKIE, 
          value:    session['auth_token'], 
          path:     '/',
          expires:  Time.now + Config::COOKIE_EXPIRATION_IN_SECS
        ) if payload.fetch('remember', false)

        p persisted_session
        persisted_session
      end
    end # post /sessions

    delete '/sessions/:id' do
      data = LogOut::Request.new(payload.merge(id: session['auth_token']))

      dispatch :delete do
        Logout::Context.new(request).run
        #auth_session = Session::Member.new(id: session['auth_token']).fetch
        session[:auth_token] = nil

        if request.cookies[Config::AUTH_TOKEN_COOKIE]
          response.delete_cookie Config::AUTH_TOKEN_COOKIE, path: '/'
        end

        if request.cookies[Config::REMEMBER_COOKIE]
          response.delete_cookie Config::REMEMBER_COOKIE , path: '/'
        end

        data.fetch(:session)
      end
    end # delete /sessions/:id
  end # API
end # Belinkr
