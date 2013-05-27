# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../../Resources/Status/Scope'

include Belinkr

describe Status::Scope do
  before do
    @user   = OpenStruct.new(id: 1)
    @user.fetch = @user
    @entity = OpenStruct.new(id: 1)
  end

  describe '#enforcer' do
    it 'returns a workspace enforcer for a workspace scope' do
      payload = { 'workspace_id' => 1 }
      scope   = Status::Scope.new(payload, @user, @entity)

      scope.enforcer.must_be_instance_of Workspace::Enforcer
    end

    it 'returns a scrapbook enforcer for a scrapbook scope' do
      payload = { 'scrapbook_id' => 1 }
      scope   = Status::Scope.new(payload, @user, @entity)

      scope.enforcer.must_be_instance_of Scrapbook::Enforcer
    end

    it 'returns a user enforcer for a user scope' do
      payload = {}
      scope   = Status::Scope.new(payload, @user, @entity)

      scope.enforcer.must_be_instance_of User::Enforcer
    end
  end #enforcer

  describe '#resource' do
    it 'returns a workspace member for a workspace scope' do
      payload = { 'workspace_id' => 1 }
      scope   = Status::Scope.new(payload, @user, @entity)

      scope.resource.must_be_instance_of Workspace::Member
    end

    it 'returns a scrapbook member for a scrapbook scope' do
      payload = { 'scrapbook_id' => 1 }
      scope   = Status::Scope.new(payload, @user, @entity)

      scope.resource.must_be_instance_of Scrapbook::Member
    end

    it 'returns a user member for a user scope' do
      payload = {}
      scope   = Status::Scope.new(payload, @user, @entity)

      scope.resource.must_equal @user
    end
  end #resource

  describe '#followers' do
    it 'returns a collection of user members for a workspace scope' do
      payload = { 'workspace_id' => 1 }
      scope   = Status::Scope.new(payload, @user, @entity)

      scope.followers.must_be_instance_of User::Collection
    end

    it 'returns an empty collection for a scrapbook scope' do
      payload = { 'scrapbook_id' => 1 }
      scope   = Status::Scope.new(payload, @user, @entity)

      scope.followers.must_be_empty
    end

    it 'returns a collection of followers for a user scope' do
      payload = {}
      scope   = Status::Scope.new(payload, @user, @entity)

      scope.followers.must_be_instance_of Follower::Collection
    end
  end #followers

  describe '#resource_timelines' do
    it 'returns some resource timeline kinds' do
      payload = {}
      scope   = Status::Scope.new(payload, @user, @entity)

      scope.resource_timelines.wont_be_empty
    end
  end #resource_timelines

  describe '#follower_timelines' do
    it 'returns some timeline kinds for a workspace scope' do
      payload = { 'workspace_id' => 1 }
      scope   = Status::Scope.new(payload, @user, @entity)

      scope.follower_timelines.wont_be_empty
    end

    it 'returns some timeline kinds for a scrapbook scope' do
      payload = { 'scrapbook_id' => 1 }
      scope   = Status::Scope.new(payload, @user, @entity)

      scope.follower_timelines.must_be_empty
    end

    it 'returns some timeline kinds for a user scope' do
      payload = { }
      scope   = Status::Scope.new(payload, @user, @entity)

      scope.follower_timelines.wont_be_empty
    end
  end #follower_timelines
end # Status::Scope

