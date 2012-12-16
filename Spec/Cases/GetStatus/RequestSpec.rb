# encoding utf-8
require 'minitest/autorun'
require 'redis'
require 'ostruct'
require 'uuidtools'
require 'Tinto/Exceptions'
require_relative '../../../Cases/GetStatus/Request'

$redis ||= Redis.new
$redis.select 8

include Belinkr

describe 'request model for GetStatus' do
  describe 'prepare data objects for scope' do
    before do
      @entity = double
      @actor  = double
    end

    it 'returns a workspace as scope if payload has a workspace_id' do
      workspace = double
      status    = status_for(workspace)
      payload   = { 'status_id' => status.id, 'workspace_id' => workspace.id }
      arguments = { payload: payload, actor: @actor, entity: @entity }

      arguments.merge!(resource: workspace)
      data      = GetStatus::Request.new(arguments).prepare

      data.fetch(:enforcer)   .must_be_instance_of Workspace::Enforcer
    end

    it 'returns a scrapbook as scope if payload has a scrapbook_id' do
      scrapbook = double
      status    = status_for(scrapbook)
      payload   = { 'status_id' => status.id, 'scrapbook_id' => 5 }
      arguments = { payload: payload, actor: @actor, entity: @entity }

      arguments.merge!(resource: scrapbook)
      data      = GetStatus::Request.new(arguments).prepare

      data.fetch(:enforcer)   .must_be_instance_of Scrapbook::Enforcer
    end

    it 'returns a user as scope by default' do
      status    = status_for(@actor)
      payload   = { 'status_id' => status.id }
      arguments = { payload: payload, actor: @actor, entity: @entity }

      arguments.merge!(resource: @actor)
      data      = GetStatus::Request.new(arguments).prepare

      data.fetch(:enforcer)   .must_be_instance_of User::Enforcer
      data.fetch(:status)     .must_be_instance_of Status::Member
      data.fetch(:actor)      .must_equal @actor
    end

    it 'raises if status is deleted' do
      status    = status_for(@actor)
      payload   = { 'status_id' => status.id }
      arguments = { payload: payload, actor: @actor, entity: @entity }

      arguments.merge!(resource: @actor)
      request   = GetStatus::Request.new(arguments)

      status.delete
      status.sync
      lambda { request.prepare }.must_raise Tinto::Exceptions::NotFound
    end
  end # prepare data objects for scope

  def double
    double = OpenStruct.new(
      id:           UUIDTools::UUID.timestamp_create.to_s,
      storage_key:  'test'
    )
  end #double

  def status_for(scope)
    Status::Member.new( text: 'test', author: @actor, scope: scope).sync
  end #status_for
end # request model for GetStatus

