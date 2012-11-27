# encoding: utf-8
require 'minitest/autorun'
require_relative '../../../Locales/Loader'
require_relative '../../../Resources/Profile/Member'
require_relative '../../../Resources/User/Member'

include Belinkr

describe Profile::Member do
  describe '#validations' do
    describe 'entity_id' do
      it 'must be present' do
        profile = Profile::Member.new
        profile.valid?.must_equal false
        profile.errors[:entity_id].must_include 'entity must not be blank'
      end
    end # entity_id

    describe 'user_id' do
      it 'must be present' do
        profile = Profile::Member.new
        profile.valid?.must_equal false
        profile.errors[:user_id].must_include 'user must not be blank'
      end
    end # user_id

    describe 'mobile' do
      it 'must be 50 characters long at most' do
        profile = Profile::Member.new(mobile: 'a' * 51)
        profile.valid?.must_equal false
        profile.errors[:mobile]
          .must_include 'mobile must be at most 50 characters long'
      end
    end # mobile

    describe 'landline' do
      it 'must be 50 characters long at most' do
        profile = Profile::Member.new(landline: 'a' * 51)
        profile.valid?.must_equal false
        profile.errors[:landline]
          .must_include 'landline must be at most 50 characters long'
      end
    end # landline

    describe 'fax' do
      it 'must be 50 characters long at most' do
        profile = Profile::Member.new(fax: 'a' * 51)
        profile.valid?.must_equal false
        profile.errors[:fax]
          .must_include 'fax must be at most 50 characters long'
      end
    end # fax

    describe 'position' do
      it 'must be 250 characters long at most' do
        profile = Profile::Member.new(position: 'a' * 251)
        profile.valid?.must_equal false
        profile.errors[:position]
          .must_include 'position must be at most 250 characters long'
      end
    end # position

    describe 'department' do
      it 'must be 250 characters long at most' do
        profile = Profile::Member.new(department: 'a' * 251)
        profile.valid?.must_equal false
        profile.errors[:department]
          .must_include 'department must be at most 250 characters long'
      end
    end # department
  end # validations

  describe '#user' do
    it 'returns the user associated to this profile' do
      profile = Profile::Member.new(user_id: 8)
      profile.user.must_be_instance_of Belinkr::User::Member
      profile.user.id.to_i.must_equal 8
    end
  end #user

  describe '#link_to' do
    it 'associates the profile to the entity' do
      profile = Profile::Member.new
      entity  = OpenStruct.new(id: 8)

      profile.link_to(entity)
      profile.entity_id.must_equal entity.id.to_s
    end
  end #link_to

  describe '#increment_followers_counter' do
    it 'increments the followers counter' do
      profile = Profile::Member.new
      profile.followers_counter.must_equal 0
      profile.increment_followers_counter
      profile.followers_counter.must_equal 1
    end
  end #increment_followers_counter

  describe '#decrement_followers_counter' do
    it 'decrements the followers counter' do
      profile = Profile::Member.new
      profile.followers_counter.must_equal 0
      profile.increment_followers_counter
      profile.followers_counter.must_equal 1
    end 
  end #decrement_followers_counter

  describe '#increment_following_counter' do
    it 'increments the following counter' do
      profile = Profile::Member.new
      profile.following_counter.must_equal 0
      profile.increment_following_counter
      profile.following_counter.must_equal 1
    end
  end #increment_following_counter

  describe '#decrement_following_counter' do
    it 'decrements the following counter' do
      profile = Profile::Member.new
      profile.following_counter.must_equal 0
      profile.increment_following_counter
      profile.following_counter.must_equal 1
    end 
  end #decrement_following_counter

  describe '#increment_status_counter' do
    it 'increments the status counter' do
      profile = Profile::Member.new
      profile.status_counter.must_equal 0
      profile.increment_status_counter
      profile.status_counter.must_equal 1
    end
  end #increment_status_counter

  describe '#decrement_status_counter' do
    it 'decrements the status counter' do
      profile = Profile::Member.new
      profile.status_counter.must_equal 0
      profile.increment_status_counter
      profile.status_counter.must_equal 1
    end 
  end #decrement_status_counter
end # Profile::Member

