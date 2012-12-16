# encoding utf-8
require 'minitest/autorun'
require 'redis'
require 'ostruct'
require 'uuidtools'
require 'Tinto/Exceptions'
require_relative '../../../Cases/GetTimeline/Request'

$redis ||= Redis.new
$redis.select 8

include Belinkr

describe 'request model for GetTimeline' do
  describe 'prepare data objects for scope' do
    before do
      @entity = double
      @actor  = double
    end

    it 'returns a workspace as scope if payload has a workspace_id' do
      workspace = double
      timeline  = timeline_for(workspace)
      payload   = { 'workspace_id' => workspace.id }
      arguments = { payload: payload, actor: @actor, entity: @entity }

      arguments.merge!(resource: workspace)
      data      = GetTimeline::Request.new(arguments).prepare

      data.fetch(:enforcer)   .must_be_instance_of Workspace::Enforcer
    end

    it 'returns a scrapbook as scope if payload has a scrapbook_id' do
      scrapbook = double
      timeline  = timeline_for(scrapbook)
      payload   = { 'scrapbook_id' => 5 }
      arguments = { payload: payload, actor: @actor, entity: @entity }

      arguments.merge!(resource: scrapbook)
      data      = GetTimeline::Request.new(arguments).prepare

      data.fetch(:enforcer)   .must_be_instance_of Scrapbook::Enforcer
    end

    it 'returns a user as scope by default' do
      timeline  = timeline_for(@actor)
      arguments = { payload: {}, actor: @actor, entity: @entity }

      arguments.merge!(resource: @actor)
      data      = GetTimeline::Request.new(arguments).prepare

      data.fetch(:enforcer)   .must_be_instance_of User::Enforcer
      data.fetch(:timeline)   .must_be_instance_of Status::Collection
      data.fetch(:actor)      .must_equal @actor
    end
  end # prepare data objects for scope

  def double
    double = OpenStruct.new(
      id:           UUIDTools::UUID.timestamp_create.to_s,
      storage_key:  'test'
    )
  end #double

  def timeline_for(scope)
    Status::Collection.new(scope: scope)
  end #timeline_for
end # request model for GetTimeline

