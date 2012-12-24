# encoding: utf-8
require_relative '../app/reply/orchestrator'
require_relative '../app/reply/collection'
require_relative '../app/reply/member'
require_relative '../app/reply/presenter'
require_relative '../app/reply/enforcer'

module Belinkr
  class API < Sinatra::Base
    get '/statuses/:status_id/replies' do
      status  = Status::Member
                .new(id: params[:status_id], entity_id: current_user.entity_id)
      replies = status.replies.select { |reply| !reply.deleted_at }
      dispatch :collection do
        Reply::Orchestrator
          .new(current_user, Reply::Enforcer, Status::Timeliner)
          .collection(status, replies)
      end
    end # get /statuses/:status_id/replies

    get '/statuses/:status_id/replies/:id' do
      status  = Status::Member
                .new(id: params[:status_id], entity_id: current_user.entity_id)
      reply   = status.replies.get params[:id]

      dispatch :read, reply do
        Reply::Orchestrator
          .new(current_user, Reply::Enforcer, Status::Timeliner)
          .read(status, reply)
      end
    end # get /statuses/:status_id/replies/:id
    
    post '/statuses/:status_id/replies' do
      status  = Status::Member
                .new(id: params[:status_id], entity_id: current_user.entity_id)
      reply   = Reply::Member.new(payload)

      dispatch :create, reply do 
        Reply::Orchestrator
          .new(current_user, Reply::Enforcer, Status::Timeliner)
          .create(status, reply)
      end
    end # post /statuses/:status_id/replies

    put '/statuses/:status_id/replies/:id' do
      status  = Status::Member
                .new(id: params[:status_id], entity_id: current_user.entity_id)
      reply   = status.replies.get params[:id]
      changes = Reply::Member.new(payload)

      dispatch :update, reply do
        Reply::Orchestrator
          .new(current_user, Reply::Enforcer, Status::Timeliner)
          .update(status, reply, changes)
      end
    end # put /statuses/:status_id/replies/:id

    delete '/statuses/:status_id/replies/:id' do
      status  = Status::Member
                .new(id: params[:status_id], entity_id: current_user.entity_id)
      reply   = status.replies.get params[:id]

      dispatch :delete, reply do
        Reply::Orchestrator
          .new(current_user, Reply::Enforcer, Status::Timeliner)
          .delete(status, reply)
      end
    end # delete /statuses/:status_id/replies/:id
  end # API
end # Belinkr