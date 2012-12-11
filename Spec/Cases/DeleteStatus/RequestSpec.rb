# encoding utf-8
require 'minitest/autorun'
require 'redis'
require 'ostruct'
require 'uuidtools'
require_relative '../../../Cases/CreateStatus/Request'
require_relative '../../../Cases/DeleteStatus/Request'

$redis ||= Redis.new
$redis.select 8

include Belinkr

describe 'request model for DeleteStatus' do
  describe 'prepare data objects for scope' do
    before do
      @entity = double
      @actor  = double
    end

    it 'returns a workspace as scope if payload has a workspace_id' do
      workspace = double
      status    = status_for(workspace)
      payload   = { 'status_id' => status.id, 'workspace_id' => workspace.id }
      data      = DeleteStatus::Request
                  .new(payload, @actor, @entity, workspace).prepare

      data.fetch(:enforcer)   .must_be_instance_of Workspace::Enforcer
    end

    it 'returns a scrapbook as scope if payload has a scrapbook_id' do
      scrapbook = double
      status    = status_for(scrapbook)
      payload   = { 'status_id' => status.id, 'scrapbook_id' => 5 }
      data      = DeleteStatus::Request
                  .new(payload, @actor, @entity, scrapbook).prepare

      data.fetch(:enforcer)   .must_be_instance_of Scrapbook::Enforcer
    end

    it 'returns a user as scope by default' do
      status  = status_for(@actor)
      payload = { 'status_id' => status.id }
      data    = DeleteStatus::Request.new(payload, @actor, @entity, @actor)
                  .prepare

      data.fetch(:enforcer)   .must_be_instance_of User::Enforcer
      data.fetch(:scope)      .must_equal @actor
      data.fetch(:status)     .must_be_instance_of Status::Member
      data.fetch(:timelines)  .wont_be_empty
      data.fetch(:actor)      .must_equal @actor
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
end # request model for DeleteStatus

