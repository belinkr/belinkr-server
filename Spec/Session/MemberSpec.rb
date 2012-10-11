# encoding: utf-8
require 'minitest/autorun'
require_relative '../../Locales/Loader'
require_relative '../../App/Session/Member'

include Belinkr

describe Session::Member do
  describe 'validations' do
    describe 'id' do
      it 'must be present' do
        session = Session::Member.new
        session.valid?.must_equal false
        session.errors[:id].must_include 'id must not be blank'
      end
    end

    describe 'user_id' do
      it 'must be present' do
        session = Session::Member.new
        session.valid?.must_equal false
        session.errors[:user_id].must_include 'user_id must not be blank'
      end

      it 'must be a number' do
        session = Session::Member.new(user_id: 'a')
        session.valid?.must_equal false
        session.errors[:user_id].must_include 'user_id must be a number'
      end
    end

    describe 'profile_id' do
      it 'must be present' do
        session = Session::Member.new
        session.valid?.must_equal false
        session.errors[:profile_id].must_include 'profile_id must not be blank'
      end

      it 'must be a number' do
        session = Session::Member.new(profile_id: 'a')
        session.valid?.must_equal false
        session.errors[:profile_id].must_include 'profile_id must be a number'
      end
    end

    describe 'entity_id' do
      it 'must be present' do
        session = Session::Member.new
        session.valid?.must_equal false
        session.errors[:entity_id].must_include 'entity_id must not be blank'
      end

      it 'must be a number' do
        session = Session::Member.new(entity_id: 'a')
        session.valid?.must_equal false
        session.errors[:entity_id].must_include 'entity_id must be a number'
      end
    end
  end # validations
end # Session::Member
