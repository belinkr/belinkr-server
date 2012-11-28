# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require 'uuidtools'
require_relative '../../Services/NewTracker'
require_relative '../../Services/NewTracker/RedisBackend'

$redis ||= Redis.new
$redis.select 8

include Belinkr::Workspace

describe 'tracker' do
  before do
    $redis.flushdb
    #backend = [Tracker::MemoryBackend.new, Tracker::RedisBackend.new].sample
    backend   = Tracker::MemoryBackend.new
    @tracker  = Tracker.new(backend)
  end

  describe '#register' do
    it 'registers the relationship' do
      entity    = factory
      user      = factory
      workspace = factory
      kind      = 'invited'

      @tracker.register(workspace, user, kind)

      @tracker.users_for(workspace, kind)         .must_include user
      @tracker.workspaces_for(entity, user, kind) .must_include workspace
    end
  end #register

  describe '#unregister' do
    it 'unregisters the relationship' do
      entity    = factory
      user      = factory
      workspace = factory
      kind      = 'invited'

      @tracker.register(workspace, user, kind)

      @tracker.users_for(workspace, kind)         .must_include user
      @tracker.workspaces_for(entity, user, kind) .must_include workspace

      @tracker.unregister(workspace, user, kind)

      @tracker.users_for(workspace, kind)         .wont_include user
      @tracker.workspaces_for(entity, user, kind) .wont_include workspace
    end
  end #unregister

  describe '#unlink_from_all_workspaces' do
    it 'unlinks the user from all workspaces' do
      entity      = factory
      user        = factory
      workspace1  = factory
      workspace2  = factory

      @tracker.register(workspace1, user, 'invited')
      @tracker.register(workspace2, user, 'autoinvited')

      @tracker.workspaces_for(entity, user, 'invited')
        .must_include workspace1
      @tracker.workspaces_for(entity, user, 'autoinvited')
        .must_include workspace2

      @tracker.unlink_from_all_workspaces(user)

      @tracker.workspaces_for(entity, user, 'invited')
        .wont_include workspace1
      @tracker.workspaces_for(entity, user, 'autoinvited')
        .wont_include workspace2
    end
  end #unlink_from_all_workspaces

  describe '#unlink_from_all_users' do
    it 'unlinks the workspace from all users' do
      entity    = factory
      workspace = factory
      user1     = factory
      user2     = factory

      @tracker.register(workspace, user1, 'invited')
      @tracker.register(workspace, user2, 'autoinvited')

      @tracker.users_for(workspace, 'invited')      .must_include user1
      @tracker.users_for(workspace, 'autoinvited')  .must_include user2

      @tracker.unlink_from_all_users(workspace)

      @tracker.users_for(workspace, 'invited')      .wont_include user1
      @tracker.users_for(workspace, 'autoinvited')  .wont_include user2
    end
  end #unlink_from_all_users

  describe '#relink_to_all_workspaces' do
    it 'relinks the user to all workspaces he was previously linked to' do
      entity      = factory
      user        = factory
      workspace1  = factory
      workspace2  = factory

      @tracker.register(workspace1, user, 'invited')
      @tracker.register(workspace2, user, 'autoinvited')

      @tracker.unlink_from_all_workspaces(user)

      @tracker.workspaces_for(entity, user, 'invited')
        .wont_include workspace1
      @tracker.workspaces_for(entity, user, 'autoinvited')
        .wont_include workspace2

      @tracker.relink_to_all_workspaces(user)

      @tracker.workspaces_for(entity, user, 'invited')
        .must_include workspace1
      @tracker.workspaces_for(entity, user, 'autoinvited')
        .must_include workspace2
    end
  end #relink_to_all_workspaces

  describe '#relink_to_all_users' do
    it 'relinks the workspaces to all users it was previously linked to' do
      entity    = factory
      workspace = factory
      user1     = factory
      user2     = factory

      @tracker.register(workspace, user1, 'invited')
      @tracker.register(workspace, user2, 'autoinvited')

      @tracker.unlink_from_all_users(workspace)

      @tracker.users_for(workspace, 'invited')      .wont_include user1
      @tracker.users_for(workspace, 'autoinvited')  .wont_include user2

      @tracker.relink_to_all_users(workspace)

      @tracker.users_for(workspace, 'invited')      .must_include user1
      @tracker.users_for(workspace, 'autoinvited')  .must_include user2
    end
  end #relink_to_all_users

  describe '#users_for' do
    it 'returns a collection of users in the workspace with this state' do
      entity    = factory
      user      = factory
      workspace = factory
      kind      = 'invited'

      @tracker.register(workspace, user, kind)

      @tracker.users_for(workspace, 'invited')        .wont_be_empty
      @tracker.users_for(workspace, 'autoinvited')    .must_be_empty
      @tracker.users_for(workspace, 'collaborator')   .must_be_empty
      @tracker.users_for(workspace, 'administrator')  .must_be_empty
    end
  end #users_for

  describe '#workspaces_for' do
    it 'returns a collection of workspaces where the user is in this state' do
      entity    = factory
      user      = factory
      workspace = factory
      kind      = 'invited'

      @tracker.register(workspace, user, kind)

      @tracker.workspaces_for(entity, user, 'invited')        .wont_be_empty
      @tracker.workspaces_for(entity, user, 'autoinvited')    .must_be_empty
      @tracker.workspaces_for(entity, user, 'collaborator')   .must_be_empty
      @tracker.workspaces_for(entity, user, 'administrator')  .must_be_empty
    end
  end #workspaces_for

  def factory
    OpenStruct.new(id: UUIDTools::UUID.timestamp_create.to_s)
  end #factory
end
