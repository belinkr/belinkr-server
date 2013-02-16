# encoding: utf-8
require_relative '../Support/Helpers'
require_relative '../../API'
require_relative '../../API/Files'
require_relative '../Factories/StoredFile'
require_relative '../Support/DocHelpers'
require 'json'

include Belinkr

$redis ||= Redis.new
$redis.select 8

describe 'File' do
  include Spec::API::Helpers
  def app; API.new; end

  Belinkr::Config.send :remove_const, 'STORAGE_ROOT'
  Belinkr::Config::STORAGE_ROOT =
    File.join(File.dirname(__FILE__), '..', '..', 'public')

  request 'POST /files' do
    outcome 'saves a file' do
      actor, profile, entity = create_user_and_profile
      file  = Rack::Test::UploadedFile.new(image_file_path, "image/png", true)
      post '/files', { file: file }, session_for(profile)

      last_response.status.must_equal 201
      response = JSON.parse(last_response.body)
      response.fetch('mime_type')         .must_equal 'image/png'
      response.fetch('original_filename') .must_equal 'logo.png'
    end
  end # POST /files

  request 'GET /files/:stored_file_id' do
    outcome 'retrieves a file' do
      actor, profile, entity      = create_user_and_profile
      http_status, stored_file_id = save_text_file_for(profile)

      get "/files/#{stored_file_id}", {}, session_for(profile)

      last_response.status  .must_equal 200
      last_response.body    .must_equal File.open(text_file_path).read
    end
  end # GET /files/:id

  request 'GET /files/:stored_file_id?version=:version' do
    outcome 'retrieves a version of the file' do
      actor, profile, entity      = create_user_and_profile
      http_status, stored_file_id = save_image_file_for(profile)

      get "/files/#{stored_file_id}?version=small&inline=true", {},
        session_for(profile)

      last_response.status  .must_equal 200
    end
  end # GET /files/:id?version=:version

  request 'DELETE /files/:id' do
    outcome 'deletes a file' do
      actor, profile, entity      = create_user_and_profile
      http_status, stored_file_id = save_text_file_for(profile)

      delete "/files/#{stored_file_id}", {}, session_for(profile)
      last_response.status  .must_equal 204
      last_response.body    .must_be_empty

      xget "/files/#{stored_file_id}", {}, session_for(profile)
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
    xpost '/files',
      { file: Rack::Test::UploadedFile.new(text_file_path, "text/plain") },
      session_for(profile)
    id = JSON.parse(last_response.body)["id"]
    [last_response.status, id]
  end

  def save_image_file_for(profile)
    xpost '/files',
      { file: Rack::Test::UploadedFile.new(image_file_path, "image/png") },
      session_for(profile)
    id = JSON.parse(last_response.body)["id"]
    [last_response.status, id]
  end
end # API
