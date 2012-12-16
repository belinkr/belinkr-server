# encoding: utf-8
require_relative '../API'
require_relative '../Config'
require_relative '../Resources/Session/Presenter'
require_relative '../Cases/LogIn/Request'
require_relative '../Cases/LogIn/Context'
require_relative '../Cases/LogOut/Request'
require_relative '../Cases/LogOut/Context'

module Belinkr
  class API < Sinatra::Base
    post '/sessions' do
      data              = LogIn::Request.new(payload: payload).prepare
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

        persisted_session
      end
    end # POST /sessions

    delete '/sessions/:id' do
      session_id  = session['auth_token'] || params.fetch('id')
      payload     = { id: session_id }
      data        = LogOut::Request.new(payload: payload).prepare
      persisted_session = data.fetch(:session)

      dispatch :delete do
        LogOut::Context.new(data).run

        session[:auth_token] = nil

        if request.cookies[Config::AUTH_TOKEN_COOKIE]
          response.delete_cookie Config::AUTH_TOKEN_COOKIE, path: '/'
        end

        if request.cookies[Config::REMEMBER_COOKIE]
          response.delete_cookie Config::REMEMBER_COOKIE , path: '/'
        end

        persisted_session
      end
    end # DELETE /sessions/:id
  end # API
end # Belinkr
