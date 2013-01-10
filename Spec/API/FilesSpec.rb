# encoding: utf-8
require 'minitest/autorun'
require 'rack/test'
require 'json'
require_relative '../../API/Files'
require_relative '../Support/Helpers'
require_relative '../Factories/StoredFile'

include Belinkr

$redis ||= Redis.new
$redis.select 8

describe API do
  def app; API.new; end
  include Rack::Test::Methods
  include Spec::API::Helpers

  Belinkr::Config.send :remove_const, 'STORAGE_ROOT'
  Belinkr::Config::STORAGE_ROOT =
    File.join(File.dirname(__FILE__), '..', '..', 'public')

  describe 'POST /files' do
    it 'saves a file' do
      actor, profile, entity = create_user_and_profile
      file  = Rack::Test::UploadedFile.new(image_file_path, "image/png", true)
      post '/files', { file: file }, session_for(profile)

      last_response.status.must_equal 201
      response = JSON.parse(last_response.body)
      response.fetch('mime_type')         .must_equal 'image/png'
      response.fetch('original_filename') .must_equal 'logo.png'
    end
  end # POST /files

  describe 'GET /files/:stored_file_id' do
    it 'retrieves a file' do
      actor, profile, entity      = create_user_and_profile
      http_status, stored_file_id = save_text_file_for(profile)

      get "/files/#{stored_file_id}", {}, session_for(profile)

      last_response.status  .must_equal 200
      last_response.body    .must_equal File.open(text_file_path).read
    end
  end # GET /files/:id

  describe 'GET /files/:stored_file_id?version=:version' do
    it 'retrieves a version of the file' do
      actor, profile, entity      = create_user_and_profile
      http_status, stored_file_id = save_image_file_for(profile)

      get "/files/#{stored_file_id}?version=small&inline=true", {},
        session_for(profile)

      last_response.status  .must_equal 200
    end
  end # GET /files/:id?version=:version

  describe 'DELETE /files/:id' do
    it 'deletes a file' do
      actor, profile, entity      = create_user_and_profile
      http_status, stored_file_id = save_text_file_for(profile)

      delete "/files/#{stored_file_id}", {}, session_for(profile)
      last_response.status  .must_equal 204
      last_response.body    .must_be_empty

      get "/files/#{stored_file_id}", {}, session_for(profile)
      last_response.status  .must_equal 404
    end
  end # DELETE /files/:id

  def text_file_path
    "#{File.dirname(__FILE__)}/../Support/foo.txt"
  end

  def image_file_path
    "#{File.dirname(__FILE__)}/../Support/logo.png"
  end

  def save_text_file_for(profile)
    post '/files',
      { file: Rack::Test::UploadedFile.new(text_file_path, "text/plain") },
      session_for(profile)
    id = JSON.parse(last_response.body)["id"]
    [last_response.status, id]
  end

  def save_image_file_for(profile)
    post '/files',
      { file: Rack::Test::UploadedFile.new(image_file_path, "image/png") },
      session_for(profile)
    id = JSON.parse(last_response.body)["id"]
    [last_response.status, id]
  end
end # API
