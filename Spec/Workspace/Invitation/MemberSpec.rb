# encoding: utf-8
require 'minitest/autorun'
require_relative '../../../Locales/Loader'
require_relative '../../../App/Workspace/Invitation/Member'

include Belinkr

describe Workspace::Invitation::Member do
  describe '#validations' do
    describe 'workspace_id' do
      it 'must be present' do
        invitation = Workspace::Invitation::Member.new
        invitation.valid?.must_equal false
        invitation.errors[:workspace_id]
          .must_include 'workspace must not be blank'
      end
    end # workspace_id

    describe 'entity_id' do
      it 'must be present' do
        invitation = Workspace::Invitation::Member.new
        invitation.valid?.must_equal false
        invitation.errors[:entity_id]
          .must_include 'entity must not be blank'
      end
    end # entity_id

    describe 'inviter_id' do
      it 'must be present' do
        invitation = Workspace::Invitation::Member.new
        invitation.valid?.must_equal false
        invitation.errors[:inviter_id].must_include 'inviter must not be blank'
      end
    end # inviter_id

    describe 'invited_id' do
      it 'must be present' do
        invitation = Workspace::Invitation::Member.new
        invitation.valid?.must_equal false
        invitation.errors[:invited_id].must_include 'invited must not be blank'
      end
    end # invited_id
  end # validation
  
  describe '#accept' do
    it 'changes the state of the invitation to accepted' do
      invitation = Workspace::Invitation::Member.new(
        inviter_id:   1, 
        invited_id:   2, 
        state:        'pending',
        workspace_id: 1, 
        entity_id:    1
      )

      invitation.accept
      invitation.state.must_equal 'accepted'
    end
  end #accept

  describe '#reject' do
    it 'changes the state of the invitation to rejected' do
      invitation = Workspace::Invitation::Member.new(
        inviter_id:   1, 
        invited_id:   2, 
        state:        'pending',
        workspace_id: 1, 
        entity_id:    1
      )

      invitation.rejected_at.must_be_nil
      invitation.reject(Time.now)
      invitation.state.must_equal 'rejected'
      invitation.rejected_at.wont_be_nil
    end
  end #reject

  describe '#accepted?' do
    it 'returns true if state is accepted' do
      invitation = Workspace::Invitation::Member.new(
        inviter_id:   1, 
        invited_id:   2, 
        workspace_id: 1, 
        entity_id:    1, 
        state:        'pending'
      )
      invitation.accept
      invitation.accepted?.must_equal true
    end
  end #accepted?

  describe '#rejected?' do
    it 'returns true if state is rejected' do
      invitation = Workspace::Invitation::Member.new(
        inviter_id:   1, 
        invited_id:   2, 
        workspace_id: 1, 
        entity_id:    1, 
        state:        'pending'
      )
      invitation.reject(Time.now)
      invitation.rejected?.must_equal true
    end
  end #rejected?
end # Workspace::Invitation::Member

