# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../../Cases/CreateWorkspace/Request'

include Belinkr

describe 'request model for create workspace' do
  it 'returns data objects for the CreateWorkspace context' do
    entity  = OpenStruct.new(id: 0)
    actor   = OpenStruct.new(id: 1)
    payload = {}

    payload   = JSON.parse(payload.to_json)
    data      = CreateWorkspace::Request.new(payload, actor, entity).prepare

    data.fetch(:actor)      .must_equal actor
    data.fetch(:entity)     .must_equal entity
    data.fetch(:workspace)  .must_be_instance_of Workspace::Member
    data.fetch(:workspaces) .must_be_instance_of Workspace::Collection
    data.fetch(:tracker)    .must_be_instance_of Workspace::Tracker
  end
end
