# encoding: utf-8
require_relative '../API'
require_relative '../Resources/Status/Presenter'
require_relative '../Cases/GetTimeline/Request'
require_relative '../Cases/GetTimeline/Context'
require_relative '../Cases/GetStatus/Request'
require_relative '../Cases/GetStatus/Context'
require_relative '../Cases/CreateStatus/Request'
require_relative '../Cases/CreateStatus/Context'
require_relative '../Cases/DeleteStatus/Request'
require_relative '../Cases/DeleteStatus/Context'

module Belinkr
  class API < Sinatra::Base
    get '/timelines' do
      dispatch :collection do
        data  = GetTimeline::Request.new(request_data).prepare
        GetTimeline::Context.new(data).run
        data.fetch(:timeline)
      end
    end # get /timelines

    get '/timelines/:kind' do
      dispatch :collection do
        data  = GetTimeline::Request.new(request_data).prepare
        GetTimeline::Context.new(data).run
        data.fetch(:timeline)
      end
    end # get /timelines/:kind

    post '/statuses' do
      data    = CreateStatus::Request.new(request_data).prepare
      status  = data.fetch(:status)

      dispatch :create, status do
        CreateStatus::Context.new(data).run
        status
      end
    end # post /statuses

    get '/statuses/:status_id' do
      dispatch :read do
        data  = GetStatus::Request.new(request_data).prepare
        GetStatus::Context.new(data).run
        data.fetch(:status)
      end
    end # get '/statuses/:status_id'

    delete '/statuses/:status_id' do
      dispatch :delete do
        data    = DeleteStatus::Request.new(request_data).prepare
        DeleteStatus::Context.new(data).run
        data.fetch(:status)
      end
    end # delete /statuses/:status_id

    #
    # Workspace scope
    #

    get '/workspaces/:workspace_id/timelines' do
      dispatch :collection do
        data  = GetTimeline::Request.new(request_data).prepare
        GetTimeline::Context.new(data).run
        data.fetch(:timeline)
      end
    end # get /workspaces/:workspace_id/timelines

    #get '/workspaces/:workspace_id/timelines/files' do
    get '/workspaces/:workspace_id/timelines/:kind' do
      dispatch :collection do
        data  = GetTimeline::Request.new(request_data).prepare
        GetTimeline::Context.new(data).run
        data.fetch(:timeline)
      end
    end # get /workspaces/:workspace_id/timelines/files

    post '/workspaces/:workspace_id/statuses' do
      data    = CreateStatus::Request.new(request_data).prepare
      status  = data.fetch(:status)

      dispatch :create, status do
        CreateStatus::Context.new(data).run
        status
      end
    end # post /workspaces/:workspace_id/statuses

    get '/workspaces/:workspace_id/statuses/:status_id' do
      dispatch :read do
        data  = GetStatus::Request.new(request_data).prepare
        GetStatus::Context.new(data).run
        data.fetch(:status)
      end
    end # get '/workspaces/:workspace_id/statuses/:status_id'

    delete '/workspaces/:workspace_id/statuses/:status_id' do
      dispatch :delete do
        data  = DeleteStatus::Request.new(request_data).prepare
        DeleteStatus::Context.new(data).run
        data.fetch(:status)
      end
    end # delete /workspaces/:workspace_id/statuses/:status_id

    #
    # Scrapbook scope
    #

    get '/scrapbooks/:scrapbook_id/timelines' do
      dispatch :collection do
        data  = GetTimeline::Request.new(request_data).prepare
        GetTimeline::Context.new(data).run
        data.fetch(:timeline)
      end
    end # get /scrapbooks/:scrapbook_id/timelines

    get '/scrapbooks/:scrapbook_id/timelines/files' do
      dispatch :collection do
        data  = GetTimeline::Request.new(request_data).prepare
        GetTimeline::Context.new(data).run
        data.fetch(:timeline)
      end
    end # get /scrapbooks/:scrapbook_id/timelines/files

    post '/scrapbooks/:scrapbook_id/statuses' do
      data    = CreateStatus::Request.new(request_data).prepare
      status  = data.fetch(:status)

      dispatch :create, status do
        CreateStatus::Context.new(data).run
        status
      end
    end # post /scrapbooks/:scrapbook_id/statuses

    get '/scrapbook/:scrapbook_id/statuses/:status_id' do
      dispatch :read do
        data  = GetStatus::Request.new(request_data).prepare
        GetStatus::Context.new(data).run
        data.fetch(:status)
      end
    end # get '/scrapbooks/:scrapbook_id/statuses/:status_id'

    delete '/scrapbooks/:scrapbook_id/statuses/:status_id' do
      dispatch :delete do
        data    = DeleteStatus::Request.new(request_data).prepare
        DeleteStatus::Context.new(data).run
        data.fetch(:status)
      end
    end # delete /scrapbooks/:scrapbook_id/statuses/:status_id
  end # API
end # Belinkr

