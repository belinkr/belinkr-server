# encoding: utf-8
require_relative '../API'
require_relative '../Resources/Scrapbook/Member'
require_relative '../Resources/Scrapbook/Collection'
require_relative '../Resources/Scrapbook/Presenter'

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
        Scrapbook::Collection.new(user_id: current_user.id, kind: 'own')
          .page(params.fetch('page', 0))
      end
    end # get /scrapbooks

    get "/scrapbooks/:scrapbook_id" do
      dispatch :read do
        Scrapbook::Member.new(
          id:       params.fetch('scrapbook_id'), 
          user_id:  current_user.id
        ).fetch
      end
    end # get /scrapbooks/:scrapbook_id

    post "/scrapbooks" do
      data      = CreateScrapbook::Request.new(payload, current_user).prepare
      scrapbook = data.fetch(:scrapbook)

      dispatch :create, scrapbook do
        CreateScrapbook::Context.new(data).run
        scrapbook
      end
    end # post /scrapbooks

    put "/scrapbooks/:scrapbook_id" do
      data      = EditScrapbook::Request.new(combined_input, current_user)
                    .prepare
      scrapbook = data.fetch(:scrapbook)

      dispatch :update, scrapbook do
        EditScrapbook::Context.new(data).run
        scrapbook
      end
    end # put /scrapbooks/:scrapbook_id
    
    delete "/scrapbooks/:scrapbook_id" do
      data      = DeleteScrapbook::Request.new(params, current_user).prepare
      scrapbook = data.fetch(:scrapbook)

      dispatch :delete do
        DeleteScrapbook::Context.new(data).run
        scrapbook
      end
    end # delete /scrapbooks/:scrapbook_id
  end # API
end # Belinkr

