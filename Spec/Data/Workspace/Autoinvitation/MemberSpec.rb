# encoding: utf-8
require 'minitest/autorun'
require_relative '../../../../Locales/Loader.rb'
require_relative '../../../../Data/Workspace/Autoinvitation/Member'

include Belinkr

describe Workspace::Autoinvitation::Member do
  describe '#validations' do
    describe 'workspace_id' do
      it 'must be present' do
        autoinvitation = Workspace::Autoinvitation::Member.new
        autoinvitation.valid?.must_equal false
        autoinvitation.errors[:workspace_id]
          .must_include 'workspace must not be blank'
      end
    end # workspace_id

    describe 'entity_id' do
      it 'must be present' do
        autoinvitation = Workspace::Autoinvitation::Member.new
        autoinvitation.valid?.must_equal false
        autoinvitation.errors[:entity_id]
          .must_include 'entity must not be blank'
      end
    end # entity_id

    describe 'invited_id' do
      it 'must be present' do
        autoinvitation = Workspace::Autoinvitation::Member.new
        autoinvitation.valid?.must_equal false
        autoinvitation.errors[:invited_id]
          .must_include 'invited must not be blank'
      end
    end # invited_id
  end # validation
  
  describe '#accept' do
    it 'changes the state of the autoinvitation to accepted' do
      autoinvitation = Workspace::Autoinvitation::Member.new(
        invited_id:   2, 
        state:        'pending',
        workspace_id: 1, 
        entity_id:    1
      )

      autoinvitation.accept
      autoinvitation.state.must_equal 'accepted'
      autoinvitation
    end
  end #accept

  describe '#reject' do
    it 'changes the state of the autoinvitation to rejected' do
      autoinvitation = Workspace::Autoinvitation::Member.new(
        invited_id:   2, 
        state:        'pending',
        workspace_id: 1, 
        entity_id:    1
      )

      autoinvitation.rejected_at.must_be_nil
      autoinvitation.reject(Time.now)
      autoinvitation
      autoinvitation.state.must_equal 'rejected'
      autoinvitation.rejected_at.wont_be_nil
    end
  end #reject

  describe '#accepted?' do
    it 'returns true if state is accepted' do
      autoinvitation = Workspace::Autoinvitation::Member.new(
        invited_id:   2, 
        workspace_id: 1, 
        entity_id:    1, 
        state:        'pending'
      )
      autoinvitation.accept
      autoinvitation.accepted?.must_equal true
    end
  end #accepted?

  describe '#rejected?' do
    it 'returns true if state is rejected' do
      autoinvitation = Workspace::Autoinvitation::Member.new(
        invited_id:   2, 
        workspace_id: 1, 
        entity_id:    1, 
        state:        'pending'
      )
      autoinvitation.reject(Time.now)
      autoinvitation.rejected?.must_equal true
    end
  end #rejected?
end # Belinkr::Workspace::Autoinvitation::Member
