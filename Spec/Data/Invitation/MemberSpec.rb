# encoding: utf-8
require 'minitest/autorun'
require_relative '../../../Locales/Loader'
require_relative '../../../Data/Invitation/Member'

include Belinkr

describe Invitation::Member do
  before do
    @invitation = Invitation::Member.new
  end

  describe '#initialize' do
    it 'generates a new token if record has not been persisted yet' do
      @invitation.valid?
      @invitation.errors[:id].wont_include 'id must be a SHA256 hash'
    end
  end #initialize

  describe 'validations' do
    describe 'entity_id' do
      it 'must be present' do
        @invitation.valid?.must_equal false
        @invitation.errors[:entity_id].must_include 'entity must not be blank'
      end
    end #entity_id

    describe 'inviter_id' do
      it 'must be present' do
        @invitation.valid?.must_equal false
        @invitation.errors[:inviter_id]
          .must_include 'inviter must not be blank'
      end
    end #inviter_id

    describe 'invited_name' do
      it 'must be present' do
        @invitation.valid?.must_equal false
        @invitation.errors[:invited_name]
          .must_include 'invited name must not be blank'
      end

      it 'is at least 1 character long' do
        @invitation.invited_name = ''
        @invitation.valid?.must_equal false
        @invitation.errors[:invited_name]
          .must_include 'invited name must be between 1 and 150 characters long'
      end

      it 'has less than 150 characters' do
        @invitation.invited_name = 'a' * 151
        @invitation.valid?.must_equal false
        @invitation.errors[:invited_name]
          .must_include 'invited name must be between 1 and 150 characters long'
      end
    end #invited_name

    describe 'invited_email' do
      it 'must be present' do
        @invitation.valid?.must_equal false
        @invitation.errors[:invited_email]
          .must_include 'invited e-mail must not be blank'
      end

      it 'has the format of an e-mail address' do
        @invitation.invited_email = 'foo'
        @invitation.valid?.must_equal false
        @invitation.errors[:invited_email]
          .must_include 'invited e-mail has an invalid format'
      end
    end

    describe 'locale' do
      it 'must be present' do
        @invitation.locale = nil
        @invitation.valid?.must_equal false
        @invitation.errors[:locale].must_include 'locale must not be blank'
      end

      it 'is one if the available locales' do
        @invitation.locale = 'de'
        @invitation.valid?.must_equal false
        @invitation.errors[:locale].must_include 'locale must be one of en, es'
      end
    end

    describe 'id' do
      it 'must be present' do
        @invitation.id = nil
        @invitation.valid?.must_equal false
        @invitation.errors[:id].must_include 'id must not be blank'
      end
    end
  end # validations

  describe 'state' do
    it 'returns the current state' do
      @invitation.state.must_equal 'pending'
    end
  end

  describe 'state=' do
    it 'assigns the current state' do
      @invitation.state = :accepted
      @invitation.state.must_equal 'accepted'
    end
  end

  describe 'pending?' do
    it 'returns true if invitation pending' do
      @invitation.pending?.must_equal true
    end
  end #pending?

  describe 'accepted?' do
    it 'returns true if invitation accepted' do
      @invitation.state = :accepted
      @invitation.accepted?.must_equal true
    end
  end #accepted?

  describe 'accept' do
    it 'transitions state to accepted' do
      @invitation.state.must_equal 'pending'
      @invitation.accept
      @invitation.accepted?.must_equal true
    end
  end #accept

  describe '#authorize' do

  end #authorize
end # Invitation::Member
