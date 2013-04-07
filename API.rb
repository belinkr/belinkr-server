# encoding: utf-8
require 'i18n'
require 'json'
require 'rack'
require 'rack/session/redis'
require 'sinatra/base'
require 'carrierwave'

require 'Tinto/Dispatcher'
require 'Tinto/Localizer'
require 'Tinto/Sanitizer'
require_relative './Locales/Loader'
require_relative './API/Invitations'
require_relative './API/Resets'
require_relative './API/Sessions'
require_relative './API/Followers'
require_relative './API/Workspaces'
require_relative './API/Scrapbooks'
require_relative './API/Files'
require_relative './API/Users'
require_relative './API/Statuses'

require_relative './Resources/Session/Member'
require_relative './Resources/User/Member'
require_relative './Resources/Entity/Member'

$redis ||= Redis.new

CarrierWave.root = Belinkr::Config::STORAGE_ROOT

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
        Tinto::Dispatcher.new(resource, scope, &block).send(action)
      end

      def scope
        { actor:  current_user, entity: current_entity }
      end #scope

      def payload
        return {} if request_body.empty?
        @payload ||= Tinto::Sanitizer.sanitize_hash(JSON.parse(request_body))
      end #payload

      def request_body
        @request_body ||= (request.body.read.to_s || "{}")
      end #request_body

      def combined_input
        payload.to_hash.merge(params)
      end #combined_input

      def sanitize_params!
        self.params = indifferent_params(Tinto::Sanitizer.sanitize_hash params)
      end

      def current_session
        return false unless session[:auth_token] || remember_cookie ||
                            auth_token_cookie || params[:auth_token]

        return @current_session if @current_session
        session[:auth_token] ||= params[:auth_token]  if params[:auth_token]
        session[:auth_token] ||= auth_token_cookie    if auth_token_cookie
        session[:auth_token] ||= remember_cookie      if remember_cookie

        begin
          @current_session = Session::Member.new(id: session[:auth_token]).fetch
        rescue Tinto::Exceptions::NotFound
          response.delete_cookie Config::AUTH_TOKEN_COOKIE, path: '/'
          return false
        end

      end

      def current_entity
        return @current_entity if @current_entity
        return Entity::Member.new unless current_session
        @current_entity ||= Entity::Member.new(id: current_session.entity_id).fetch
      end

      def current_user
        return User::Member.new unless current_session
        @current_user ||= User::Member.new(id: current_session.user_id).fetch
      end

      def current_profile
        return Profile::Member.new unless current_session
        @current_profile ||= Profile::Member.new(
          id:         current_session.profile_id,
          entity_id:  current_session.entity_id
        ).fetch
      end

      def request_data
        @request_data ||= {
          payload:    combined_input,
          actor:      current_user,
          entity:     current_entity
        }
      end #request_data

      def auth_token_cookie
        token = request.cookies[Config::AUTH_TOKEN_COOKIE]
        token && !token.empty? ? token : false
      end

      def remember_cookie
        token = request.cookies[Config::REMEMBER_COOKIE]
        token && !token.empty? ? token : false
      end

      def public_path?
        request.path_info =~ %r{sessions|resets|invitations/\w+}
      end
    end
  end # API
end # Belinkr
