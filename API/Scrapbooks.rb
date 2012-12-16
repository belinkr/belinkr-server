# encoding: utf-8
require_relative '../API'
require_relative '../Resources/Scrapbook/Member'
require_relative '../Resources/Scrapbook/Collection'
require_relative '../Resources/Scrapbook/Enforcer'
require_relative '../Resources/Scrapbook/Presenter'

require_relative '../Cases/GetMember/Request'
require_relative '../Cases/GetMember/Context'
require_relative '../Cases/GetCollection/Request'
require_relative '../Cases/GetCollection/Context'
require_relative '../Cases/CreateScrapbook/Request'
require_relative '../Cases/CreateScrapbook/Context'
require_relative '../Cases/EditScrapbook/Request'
require_relative '../Cases/EditScrapbook/Context'
require_relative '../Cases/DeleteScrapbook/Request'
require_relative '../Cases/DeleteScrapbook/Context'

module Belinkr
  class API < Sinatra::Base
    get "/scrapbooks" do
      dispatch :collection do
        request_data.merge!(kind: :scrapbook)
        data = GetCollection::Request.new(request_data).prepare
        GetCollection::Context.new(data).run
        data.fetch(:collection)
      end
    end # get /scrapbooks

    get "/scrapbooks/:scrapbook_id" do
      dispatch :read do
        request_data.merge!(kind: :scrapbook)
        data = GetMember::Request.new(request_data).prepare
        GetMember::Context.new(data).run
        data.fetch(:member)
      end
    end # get /scrapbooks/:scrapbook_id

    post "/scrapbooks" do
      data      = CreateScrapbook::Request.new(request_data).prepare
      scrapbook = data.fetch(:scrapbook)

      dispatch :create, scrapbook do
        CreateScrapbook::Context.new(data).run
        scrapbook
      end
    end # post /scrapbooks

    put "/scrapbooks/:scrapbook_id" do
      data      = EditScrapbook::Request.new(request_data).prepare
      scrapbook = data.fetch(:scrapbook)

      dispatch :update, scrapbook do
        EditScrapbook::Context.new(data).run
        scrapbook
      end
    end # put /scrapbooks/:scrapbook_id
    
    delete "/scrapbooks/:scrapbook_id" do
      data      = DeleteScrapbook::Request.new(request_data).prepare
      scrapbook = data.fetch(:scrapbook)

      dispatch :delete do
        DeleteScrapbook::Context.new(data).run
        scrapbook
      end
    end # delete /scrapbooks/:scrapbook_id
  end # API
end # Belinkr

