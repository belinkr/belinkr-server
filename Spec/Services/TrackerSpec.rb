# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require 'uuidtools'
require_relative '../../Services/Tracker'

$redis ||= Redis.new
$redis.select 8

include Belinkr::Workspace

describe 'tracker' do
  before do
    $redis.flushdb
    #backend = [Tracker::MemoryBackend.new, Tracker::RedisBackend.new].sample
    backend   = Tracker::RedisBackend.new
    @tracker  = Tracker.new(backend)
  end

  describe '#track_administrator' do
    it 'tracks a user as administrator of the workspace' do
      entity    = double
      user      = double
      workspace = double
      kind      = 'administrator'

      @tracker.track_administrator(workspace, user)

      @tracker.users_for(workspace, kind)         .must_include user
      @tracker.workspaces_for(entity, user, kind) .must_include workspace
      @tracker.relationship_for(workspace, user)  .must_equal 'administrator'
    end
  end #track_administrator

  describe '#track_collaborator' do
    it 'tracks a user as collaborator of the workspace' do
      entity    = double
      user      = double
      workspace = double
      kind      = 'collaborator'

      @tracker.track_collaborator(workspace, user)

      @tracker.users_for(workspace, kind)         .must_include user
      @tracker.workspaces_for(entity, user, kind) .must_include workspace
      @tracker.relationship_for(workspace, user)  .must_equal 'collaborator'
    end
  end #track_collaborator

  describe '#track_invitation' do
    it 'tracks a user as invited to the workspace' do
      entity      = double
      user        = double
      workspace   = double
      invitation  = double
      kind        = 'invited'

      @tracker.track_invitation(workspace, user, invitation)

      @tracker.users_for(workspace, kind)         .must_include user
      @tracker.workspaces_for(entity, user, kind) .must_include workspace
      @tracker.relationship_for(workspace, user)  .must_match /invitation/
    end
  end #track_invitation

  describe '#track_autoinvitation' do
    it 'tracks a user as autoinvited to the workspace' do
      entity          = double
      user            = double
      workspace       = double
      autoinvitation  = double
      kind            = 'autoinvited'

      @tracker.track_autoinvitation(workspace, user, autoinvitation)

      @tracker.users_for(workspace, kind)         .must_include user
      @tracker.workspaces_for(entity, user, kind) .must_include workspace
      @tracker.relationship_for(workspace, user)  .must_match /autoinvitation/
    end
  end #track_autoinvitation


  describe '#untrack_invitation' do
    it 'untracks a user as invited to the workspace' do
      entity      = double
      user        = double
      workspace   = double
      invitation  = double
      kind        = 'invited'

      @tracker.track_invitation(workspace, user, invitation)

      @tracker.users_for(workspace, kind)         .must_include user
      @tracker.workspaces_for(entity, user, kind) .must_include workspace
      @tracker.relationship_for(workspace, user)  .must_match /invitation/

      @tracker.untrack_invitation(workspace, user, invitation)

      @tracker.users_for(workspace, kind)         .wont_include user
      @tracker.workspaces_for(entity, user, kind) .wont_include workspace
      @tracker.relationship_for(workspace, user)  .must_be_nil
    end
  end #untrack_invitation

  describe '#untrack_autoinvitation' do
    it 'untracks a user as autoinvited to the workspace' do
      entity          = double
      user            = double
      workspace       = double
      autoinvitation  = double
      kind            = 'autoinvited'

      @tracker.track_autoinvitation(workspace, user, autoinvitation)

      @tracker.users_for(workspace, kind)         .must_include user
      @tracker.workspaces_for(entity, user, kind) .must_include workspace
      @tracker.relationship_for(workspace, user)  .must_match /autoinvitation/

      @tracker.untrack_autoinvitation(workspace, user, autoinvitation)

      @tracker.users_for(workspace, kind)         .wont_include user
      @tracker.workspaces_for(entity, user, kind) .wont_include workspace
      @tracker.relationship_for(workspace, user)  .must_be_nil
    end
  end #untrack_autoinvitation

  describe '#remove' do
  end #remove

  describe '#unlink_all_workspaces_from' do
    it 'unlinks the user from all workspaces' do
      entity      = double
      user        = double
      workspace1  = double
      workspace2  = double

      @tracker.track_collaborator(workspace1, user)
      @tracker.track_collaborator(workspace2, user)

      @tracker.users_for(workspace1, 'collaborator').must_include user
      @tracker.users_for(workspace2, 'collaborator').must_include user

      @tracker.unlink_from_all_workspaces(user)

      @tracker.users_for(workspace1, 'collaborator').wont_include user
      @tracker.users_for(workspace2, 'collaborator').wont_include user
    end
  end #unlink_all_workspaces_from

  describe '#unlink_from_all_users' do
    it 'unlinks the workspace from all users' do
      entity    = double
      workspace = double
      user1     = double
      user2     = double

      @tracker.track_administrator(workspace, user1)
      @tracker.track_collaborator(workspace, user2)

      @tracker.workspaces_for(entity, user1, 'administrator')
        .must_include workspace 
      @tracker.workspaces_for(entity, user2, 'collaborator')
        .must_include workspace

      @tracker.unlink_from_all_users(workspace)

      @tracker.workspaces_for(entity, user1, 'administrator')
        .wont_include workspace 
      @tracker.workspaces_for(entity, user2, 'collaborator')
        .wont_include workspace
    end
  end #unlink_from_all_users

  describe '#relink_to_all_workspaces' do
    it 'relinks the user to all workspaces he was previously linked to' do
      entity      = double
      user        = double
      workspace1  = double
      workspace2  = double

      @tracker.track_collaborator(workspace1, user)
      @tracker.track_collaborator(workspace2, user)

      @tracker.unlink_from_all_workspaces(user)

      @tracker.users_for(workspace1, 'collaborator').wont_include user
      @tracker.users_for(workspace2, 'collaborator').wont_include user

      @tracker.relink_to_all_workspaces(user)

      @tracker.users_for(workspace1, 'collaborator').must_include user
      @tracker.users_for(workspace2, 'collaborator').must_include user
    end
  end #relink_to_all_workspaces

  describe '#relink_to_all_users' do
    it 'relinks the workspaces to all users it was previously linked to' do
      entity    = double
      workspace = double
      user1     = double
      user2     = double

      @tracker.track_administrator(workspace, user1)
      @tracker.track_collaborator(workspace, user2)

      @tracker.unlink_from_all_users(workspace)

      @tracker.workspaces_for(entity, user1, 'administrator')
        .wont_include workspace 
      @tracker.workspaces_for(entity, user2, 'collaborator')
        .wont_include workspace

      @tracker.relink_to_all_users(workspace)

      @tracker.workspaces_for(entity, user1, 'administrator')
        .must_include workspace 
      @tracker.workspaces_for(entity, user2, 'collaborator')
        .must_include workspace
    end
  end #relink_to_all_users

  describe '#users_for' do
    it 'returns a collection of users in the workspace with this state' do
      entity      = double
      user        = double
      workspace   = double
      invitation  = double

      @tracker.track_invitation(workspace, user, invitation)

      @tracker.users_for(workspace, 'invited')        .wont_be_empty
      @tracker.users_for(workspace, 'autoinvited')    .must_be_empty
      @tracker.users_for(workspace, 'collaborator')   .must_be_empty
      @tracker.users_for(workspace, 'administrator')  .must_be_empty
    end
  end #users_for

  describe '#workspaces_for' do
    it 'returns a collection of workspaces where the user is in this state' do
      entity      = double
      user        = double
      workspace   = double
      invitation  = double

      @tracker.track_invitation(workspace, user, invitation)

      @tracker.workspaces_for(entity, user, 'invited')        .wont_be_empty
      @tracker.workspaces_for(entity, user, 'autoinvited')    .must_be_empty
      @tracker.workspaces_for(entity, user, 'collaborator')   .must_be_empty
      @tracker.workspaces_for(entity, user, 'administrator')  .must_be_empty
    end
  end #workspaces_for

  describe '#relationship_for' do
    it 'returns the relationship of a user with a workspace' do
      workspace       = double
      invitation      = double
      autoinvitation  = double
      administrator   = double
      collaborator    = double
      invited         = double
      autoinvited     = double

      @tracker.track_administrator(workspace, administrator)
      @tracker.relationship_for(workspace, administrator)
        .must_equal 'administrator'

      @tracker.track_collaborator(workspace, collaborator)
      @tracker.relationship_for(workspace, collaborator)
        .must_equal 'collaborator'

      @tracker.track_invitation(workspace, invited, autoinvitation)
      @tracker.relationship_for(workspace, invited).must_match /invitation/

      @tracker.track_autoinvitation(workspace, autoinvited, autoinvitation)
      @tracker.relationship_for(workspace, autoinvited)
        .must_match /autoinvitation/
    end
  end #relationship_for

  describe '#invitation_for' do
    it 'returns an invitation member given a user and a workspace' do
      workspace   = double
      invited     = double
      invitation  = double

      @tracker.track_invitation(workspace, invited, invitation)
      @tracker.invitation_for(workspace, invited).id.must_equal invitation.id
    end

    it 'raises if the user is not invited to the workspace' do
      workspace         = double
      not_involved_user = double

      lambda { @tracker.invitation_for(workspace, not_involved_user) }
        .must_raise Tinto::Exceptions::InvalidResource
    end
  end #invitation_for

  describe '#autoinvitaiton_for' do
    it 'returns an autoinvitation member given a user and a workspace' do
      workspace       = double
      autoinvited     = double
      autoinvitation  = double

      @tracker.track_autoinvitation(workspace, autoinvited, autoinvitation)
      @tracker.invitation_for(workspace, autoinvited)
        .id.must_equal autoinvitation.id
    end

    it 'raises if the user is not autoinvited to the workspace' do
      workspace         = double
      not_involved_user = double

      lambda { @tracker.autoinvitation_for(workspace, not_involved_user) }
        .must_raise Tinto::Exceptions::InvalidResource
    end
  end #autoinvitaiton_for

  def double
    OpenStruct.new(id: UUIDTools::UUID.timestamp_create.to_s)
  end #double
end

