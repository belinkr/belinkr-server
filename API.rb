# encoding: utf-8
require 'i18n'
require 'json'
require 'rack'
require 'rack/session/redis'
require 'sinatra/base'
require 'carrierwave'

require_relative './Tinto/Dispatcher'
require_relative './Tinto/Localizer'
require_relative './Tinto/Sanitizer'
require_relative './Locales/Loader'
require_relative 'API/Invitations'
require_relative 'API/Resets'
require_relative 'API/Sessions'
require_relative 'API/Users'

require_relative 'App/Session/Member'
require_relative 'App/User/Member'
require_relative 'App/Entity/Member'

$redis ||= Redis.new

CarrierWave.root = File.join(File.dirname(__FILE__), 'public')

module Belinkr
  class API < Sinatra::Base
    set :protection,      except: [:remote_token, :frame_options]
    set :root,            File.dirname(__FILE__)
    set :public_folder,   CarrierWave.root
    set :session_secret,  Config::SESSION_SECRET

    before do
      sanitize_params!
      halt 401 unless public_path? || current_session

      I18n.locale = Tinto::Localizer.new(self).locale
      unless request.cookies[Config::LOCALE_COOKIE]
        response.set_cookie Config::LOCALE_COOKIE, value: I18n.locale, path: "/"
      end
    end

    helpers do
      def dispatch(action, resource=nil, &block)
        Tinto::Dispatcher.new(current_user, resource, &block).send(action)
      end

      def payload
        @payload ||= 
          Tinto::Sanitizer.sanitize_hash(JSON.parse(request.body.read.to_s))
      end

      def sanitize_params!
        self.params = 
          send(:indifferent_params, Tinto::Sanitizer.sanitize_hash(params))
      end

      def current_session
        return false unless session[:auth_token] || remember_cookie ||
                            auth_token_cookie || params[:auth_token]

        return @current_session if @current_session
        session[:auth_token] ||= params[:auth_token]  if params[:auth_token]
        session[:auth_token] ||= auth_token_cookie    if auth_token_cookie
        session[:auth_token] ||= remember_cookie      if remember_cookie

        @current_session = Session::Member.new(id: session[:auth_token]).fetch
      end

      def current_entity
        @current_entity ||= Entity::Member.new(id: current_session.entity_id).fetch
        @current_entity
      end

      def current_user
        return false unless current_session
        @current_user ||= User::Member.new(id: current_session.user_id).fetch
      end
      
      def auth_token_cookie
        token = request.cookies[Config::AUTH_TOKEN_COOKIE] 
        token && !token.empty? ? token : false
      end

      def remember_cookie
        token = request.cookies[Config::REMEMBER_COOKIE] 
        token && !token.empty? ? token : false
      end

      def public_path?
        request.path_info =~ %r{sessions|login|resets|invitations/\w+}
      end
    end
  end # API
end # Belinkr
