# encoding: utf-8
require 'minitest/autorun'
require 'minitest/mock'
require 'rack/test'
require 'json'
require_relative '../../API'
require_relative '../../API/Sessions'

require_relative '../Factories/User'
require_relative '../Factories/Profile'
require_relative '../Factories/Entity'
require_relative '../Support/Helpers'
require_relative '../../Resources/Profile/Collection'
require_relative '../../Resources/Session/Member'
require_relative '../../Cases/CreateProfileInEntity/Context'
require_relative '../Support/DocHelpers'

include Belinkr
$redis ||= Redis.new
$redis.select 8

describe API do
  def app; API.use Rack::Session::Redis; API.new; end
  include Spec::API::Helpers

  before { $redis.flushdb }

  request 'POST /sessions' do
    outcome 'authenticates the user and creates a new session' do
      user, profile, password = create_account
      post '/sessions', { email: user.email, password: password }.to_json
      last_response.status.must_equal 201

      xget '/users'
      last_response.status.wont_equal 401

      unregister_redis_session_extension
    end

    outcome 'stores the session token in a persistent cookie if "remember" option' do
      user, profile, password = create_account
      rack_mock_session.cookie_jar[Belinkr::Config::REMEMBER_COOKIE]
        .must_be_nil
      post '/sessions',
        { email: user.email, password: password, remember: true }.to_json

      last_response.status.must_equal 201
      rack_mock_session.cookie_jar[Belinkr::Config::REMEMBER_COOKIE]
        .wont_be_nil

      unregister_redis_session_extension
    end

    outcome 'sets a non-persistent cookie marking the user-agent as "logged in"' do
      user, profile, password = create_account
      rack_mock_session.cookie_jar[Belinkr::Config::AUTH_TOKEN_COOKIE]
        .must_be_nil
      post '/sessions',
        { email: user.email, password: password, remember: true }.to_json

      last_response.status.must_equal 201
      rack_mock_session.cookie_jar[Belinkr::Config::AUTH_TOKEN_COOKIE]
        .wont_be_nil

      unregister_redis_session_extension
    end
  end # POST /sessions

  request 'DELETE /sessions/:id' do
    outcome 'clears the session' do
      user, profile, password = create_account

      post '/sessions', { email: user.email, password: password }.to_json
      rack_mock_session.cookie_jar[Belinkr::Config::REMEMBER_COOKIE]
        .must_be_nil
      rack_mock_session.cookie_jar[Belinkr::Config::AUTH_TOKEN_COOKIE]
        .wont_be_nil

      delete '/sessions/1', {}, session_for(profile)

      last_response.status.must_equal 204
      last_response.body.must_be_empty

      rack_mock_session.cookie_jar[Belinkr::Config::REMEMBER_COOKIE]
        .must_be_nil
      rack_mock_session.cookie_jar[Belinkr::Config::AUTH_TOKEN_COOKIE]
        .must_be_empty

      user, profile, password = create_account
      post '/sessions',
        { email: user.email, password: password, remember: true }.to_json

      rack_mock_session.cookie_jar[Belinkr::Config::REMEMBER_COOKIE]
        .wont_be_nil

      delete '/sessions/1', {}.to_json, session_for(user.profiles.first)
      rack_mock_session.cookie_jar[Belinkr::Config::REMEMBER_COOKIE]
        .must_be_empty
      rack_mock_session.cookie_jar[Belinkr::Config::AUTH_TOKEN_COOKIE]
        .must_be_empty

      get '/scrapbooks'
      last_response.status.must_equal 401

      unregister_redis_session_extension
    end
  end # DELETE /sessions/:id

  request 'auth_token HTTP params' do
    outcome 'gets the auth_token from params for Flash uploads' do
      user, profile, password = create_account
      post '/sessions', { email: user.email, password: password }.to_json
      token = rack_mock_session.cookie_jar[Belinkr::Config::AUTH_TOKEN_COOKIE]

      file  = Rack::Test::UploadedFile.new(image_file_path, "image/png", true)
      post "/files?auth_token=#{token}", { file: file }
      last_response.status.must_equal 201
      unregister_redis_session_extension
    end
  end

  request 'general settings in cookies' do
    outcome 'sets a cookie for the locale' do
      user, profile, password = create_account
      rack_mock_session.cookie_jar[Belinkr::Config::LOCALE_COOKIE].must_be_nil
      post '/sessions', { email: user.email, password: password }.to_json
      rack_mock_session.cookie_jar[Belinkr::Config::LOCALE_COOKIE]
        .must_equal 'en'
      unregister_redis_session_extension
    end
  end

  def create_account
    entity    = Factory.entity.sync
    user      = Factory.user(password: 'test', profiles: [])
    profile   = Factory.profile
    profiles  = Profile::Collection.new(entity_id: entity.id)
    context   = CreateProfileInEntity::Context.new(
                  actor:    user,
                  profile:  profile,
                  profiles: profiles,
                  entity:   entity
                )
    context.call
    context.sync
    [user, profile, 'test']
  end

  def unregister_redis_session_extension
    Belinkr::API.instance_variable_get(:@middleware).pop
  end

  def image_file_path
    "#{File.dirname(__FILE__)}/../Support/logo.png"
  end
end # API
