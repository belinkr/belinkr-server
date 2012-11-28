# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative './Tracker'
require_relative './RedisBackend'

$redis ||= Redis.new
$redis.select 8

include Belinkr::Workspace

describe 'tracker' do
  before do
    $redis.flushdb
    backend = [Tracker::MemoryBackend.new, Tracker::RedisBackend.new].sample
    @tracker = Tracker.new(backend)
  end

  describe '#register' do
    it 'registers the relationship' do
      user      = OpenStruct.new(id: 1)
      workspace = OpenStruct.new(id: 2, entity_id: 3)
      kind      = 'invited'

      @tracker.register(workspace, user, kind)

      @tracker.users_for(workspace, kind) .must_include user.id.to_s
      @tracker.workspaces_for(user, kind) .must_include workspace.id.to_s
    end
  end #register

  describe '#unregister' do
    it 'unregisters the relationship' do
      user      = OpenStruct.new(id: 1)
      workspace = OpenStruct.new(id: 2, entity_id: 3)
      kind      = 'invited'

      @tracker.register(workspace, user, kind)

      @tracker.users_for(workspace, kind) .must_include user.id.to_s
      @tracker.workspaces_for(user, kind) .must_include workspace.id.to_s

      @tracker.unregister(workspace, user, kind)

      @tracker.users_for(workspace, kind) .wont_include user.id.to_s
      @tracker.workspaces_for(user, kind) .wont_include workspace.id.to_s
    end
  end #unregister

  describe '#unlink_from_all_workspaces' do
    it 'unlinks the user from all workspaces' do
      user        = OpenStruct.new(id: 1)
      workspace1  = OpenStruct.new(id: 2, entity_id: 3)
      workspace2  = OpenStruct.new(id: 3, entity_id: 3)

      @tracker.register(workspace1, user, 'invited')
      @tracker.register(workspace2, user, 'autoinvited')

      @tracker.workspaces_for(user, 'invited')      .must_include workspace1.id.to_s
      @tracker.workspaces_for(user, 'autoinvited')  .must_include workspace2.id.to_s

      @tracker.unlink_from_all_workspaces(user)

      @tracker.workspaces_for(user, 'invited')      .wont_include workspace1.id.to_s
      @tracker.workspaces_for(user, 'autoinvited')  .wont_include workspace2.id.to_s
    end
  end #unlink_from_all_workspaces

  describe '#unlink_from_all_users' do
    it 'unlinks the workspace from all users' do
      workspace = OpenStruct.new(id: 2, entity_id: 3)
      user1     = OpenStruct.new(id: 4)
      user2     = OpenStruct.new(id: 5)

      @tracker.register(workspace, user1, 'invited')
      @tracker.register(workspace, user2, 'autoinvited')

      @tracker.users_for(workspace, 'invited')      .must_include user1.id.to_s
      @tracker.users_for(workspace, 'autoinvited')  .must_include user2.id.to_s

      @tracker.unlink_from_all_users(workspace)

      @tracker.users_for(workspace, 'invited')      .wont_include user1.id.to_s
      @tracker.users_for(workspace, 'autoinvited')  .wont_include user2.id.to_s
    end
  end #unlink_from_all_users

  describe '#relink_to_all_workspaces' do
    it 'relinks the user to all workspaces he was previously linked to' do
      user        = OpenStruct.new(id: 1)
      workspace1  = OpenStruct.new(id: 2, entity_id: 3)
      workspace2  = OpenStruct.new(id: 3, entity_id: 3)

      @tracker.register(workspace1, user, 'invited')
      @tracker.register(workspace2, user, 'autoinvited')

      @tracker.unlink_from_all_workspaces(user)

      @tracker.workspaces_for(user, 'invited')      .wont_include workspace1.id.to_s
      @tracker.workspaces_for(user, 'autoinvited')  .wont_include workspace2.id.to_s

      @tracker.relink_to_all_workspaces(user)

      @tracker.workspaces_for(user, 'invited')      .must_include workspace1.id.to_s
      @tracker.workspaces_for(user, 'autoinvited')  .must_include workspace2.id.to_s
    end
  end #relink_to_all_workspaces

  describe '#relink_to_all_users' do
    it 'relinks the workspaces to all users it was previously linked to' do
      workspace = OpenStruct.new(id: 2, entity_id: 3)
      user1     = OpenStruct.new(id: 4)
      user2     = OpenStruct.new(id: 5)

      @tracker.register(workspace, user1, 'invited')
      @tracker.register(workspace, user2, 'autoinvited')

      @tracker.unlink_from_all_users(workspace)

      @tracker.users_for(workspace, 'invited')      .wont_include user1.id.to_s
      @tracker.users_for(workspace, 'autoinvited')  .wont_include user2.id.to_s

      @tracker.relink_to_all_users(workspace)

      @tracker.users_for(workspace, 'invited')      .must_include user1.id.to_s
      @tracker.users_for(workspace, 'autoinvited')  .must_include user2.id.to_s
    end
  end #relink_to_all_users

  describe '#users_for' do
    it 'returns a collection of users in the workspace with this state' do
      user      = OpenStruct.new(id: 1)
      workspace = OpenStruct.new(id: 2, entity_id: 3)
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
      user      = OpenStruct.new(id: 1)
      workspace = OpenStruct.new(id: 2, entity_id: 3)
      kind      = 'invited'

      @tracker.register(workspace, user, kind)

      @tracker.workspaces_for(user, 'invited')        .wont_be_empty
      @tracker.workspaces_for(user, 'autoinvited')    .must_be_empty
      @tracker.workspaces_for(user, 'collaborator')   .must_be_empty
      @tracker.workspaces_for(user, 'administrator')  .must_be_empty
    end
  end #workspaces_for
end

