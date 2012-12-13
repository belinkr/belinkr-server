# encoding: utf-8
require_relative '../API'
require_relative '../Resources/StoredFile/Presenter'

require_relative '../Cases/StoreFile/Request'
require_relative '../Cases/StoreFile/Context'
require_relative '../Cases/GetStoredFile/Request'
require_relative '../Cases/DeleteStoredFile/Request'
require_relative '../Cases/DeleteStoredFile/Context'

module Belinkr
  class API < Sinatra::Base
    post '/files' do
      data        = StoreFile::Request.new(params, current_user).prepare
      stored_file = data.fetch(:stored_file)

      StoreFile::Context.new(data).run
      [201, StoredFile::Presenter.new(stored_file, current_user).as_json]
    end # post /files

    get '/files/:stored_file_id' do
      data = GetStoredFile::Request.new(params, current_user).prepare

      http_options      = data.fetch(:http_options)
      stored_file_path  = data.fetch(:stored_file_path)
      send_file stored_file_path, http_options
    end # get /files/:stored_file_id

    delete '/files/:stored_file_id' do
      data = DeleteStoredFile::Request.new(params, current_user).prepare
      DeleteStoredFile::Context.new(data).run
      [204]
    end # delete /files/:stored_file_id
  end # API
end # Belinkr

