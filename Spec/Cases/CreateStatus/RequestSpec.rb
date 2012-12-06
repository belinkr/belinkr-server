# encoding utf-8
require 'minitest/autorun'
require 'redis'
require 'ostruct'
require_relative '../../../Cases/CreateStatus/Request'


$redis ||= Redis.new
$redis.select 8

include Belinkr

describe 'request model for CreateStatus' do
  describe 'prepare data objects for scope' do
    before do
      @entity   = OpenStruct.new(id: 1)
      @actor    = OpenStruct.new(id: 2)
      @profile  = Profile::Member.new(id: 3)
    end

    it 'returns a workspace as scope if payload has a workspace_id' do
      payload = { 'workspace_id' => 5 }
      data    = CreateStatus::Request.new(payload, @actor, @profile, @entity)
                  .prepare

      data.fetch(:enforcer).must_be_instance_of Workspace::Enforcer
      data.wont_include :follower_timelines
    end

    it 'returns a scrapbook as scope if payload has a scrapbook_id' do
      payload = { 'scrapbook_id' => 5 }
      data    = CreateStatus::Request.new(payload, @actor, @profile, @entity)
                  .prepare

      data.fetch(:enforcer).must_be_instance_of Scrapbook::Enforcer
      data.wont_include :follower_timelines
    end

    it 'returns a profile as scope by default' do
      payload = {}
      data    = CreateStatus::Request.new(payload, @actor, @profile, @entity)
                  .prepare

      data.fetch(:enforcer)   .must_be_instance_of User::Enforcer
      data.fetch(:status)     .must_be_instance_of Status::Member
      data.fetch(:actor)      .must_equal @actor
    end
  end # prepare data objects for scope
end # request model for CreateStatus

