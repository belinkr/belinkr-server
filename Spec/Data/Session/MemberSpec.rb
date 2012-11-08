# encoding: utf-8
require 'minitest/autorun'
require_relative '../../../Locales/Loader'
require_relative '../../../Data/Session/Member'

include Belinkr

describe Session::Member do
  describe 'validations' do
    describe 'user_id' do
      it 'must be present' do
        session = Session::Member.new
        session.valid?.must_equal false
        session.errors[:user_id].must_include 'user_id must not be blank'
      end
    end

    describe 'profile_id' do
      it 'must be present' do
        session = Session::Member.new
        session.valid?.must_equal false
        session.errors[:profile_id].must_include 'profile_id must not be blank'
      end
    end

    describe 'entity_id' do
      it 'must be present' do
        session = Session::Member.new
        session.valid?.must_equal false
        session.errors[:entity_id].must_include 'entity_id must not be blank'
      end
    end
  end # validations

  describe '#expire' do
    it 'destroys the sesssion' do
      session = Session::Member.new(user_id: 1, profile_id: 1, entity_id: 1)
      session.expire
      session.attributes.each { |attribute, value| value.must_be_nil }
    end
  end #expire
end # Session::Member

