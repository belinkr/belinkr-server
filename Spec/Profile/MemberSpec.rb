# encoding: utf-8
require 'minitest/autorun'
require_relative '../../Locales/Loader'
require_relative '../../App/Profile/Member'

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
end # Profile::Member
