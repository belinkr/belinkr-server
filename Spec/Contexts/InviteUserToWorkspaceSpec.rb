require 'minitest/autorun'

describe 'invite user to workspace' do

  it 'raises if the actor is not a collaborator or administrator' do
    context = InviteUserToWorkspace
      .new(@actor, @workspace, @invitation, @invitations, memberships)
    lambda { context.call }.must_raise NotAllowed
  end

  it 'creates an invitation' do
    @invitations.wont_include @invitation
    context = InviteUserToWorkspace
      .new(@actor, @workspace, @invitation, @invitations, memberships)
    context.users.push @actor
    @invitations.must_include @invitation
  end

  it 'adds the workspace to the invited collection of the user' do
    @memberships.first.wont_include @workspace
    @memberships.first.must_include @workspace
  end

  it 'registers the invitation membership in the workspace tracker' do
    @memberships.first.wont_include @workspace
    @memberships.first.must_include @workspace
  end
end
