# encoding: utf-8
require 'minitest/autorun'
require_relative '../../Locales/Loader'
require_relative '../../App/User/Member'

include Belinkr

describe User::Member do
  describe '#validations' do
    describe 'first' do
      it 'must be present' do
        user = User::Member.new
        user.valid?.must_equal false
        user.errors[:first].must_include 'first name must not be blank'
      end

      it 'must be 50 characters long at most' do
        user = User::Member.new(first: 'a' * 51)
        user.valid?.must_equal false
        user.errors[:first]
          .must_include 'first name must be at most 50 characters long'
      end
    end # first

    describe 'last' do
      it 'must be present' do
        user = User::Member.new
        user.valid?.must_equal false
        user.errors[:last].must_include 'last name must not be blank'
      end

      it 'must be 50 characters long at most' do
        user = User::Member.new(last: 'a' * 51)
        user.valid?.must_equal false
        user.errors[:last]
          .must_include 'last name must be at most 50 characters long'
      end
    end # last

    describe 'name_order' do
      it 'must be present' do
        user = User::Member.new
        user.name_order = nil
        user.valid?.must_equal false
        user.errors[:name_order].must_include 'name order must not be blank'
      end

      it 'must be one of the two options' do
        skip
        user = User::Member.new(name_order: 'invalid')
        user.valid?.must_equal false
        user.errors[:name_order].must_include 'name order must not be blank'

        user = User::Member.new(name_order: 'first-last')
        user.valid?.must_equal true

        user = User::Member.new(name_order: 'last-first')
        user.valid?.must_equal true
      end
    end # name_order

    describe '#password' do
      it 'at least 1 character long' do
        user = User::Member.new(password: '')
        user.valid?.must_equal false
        user.errors[:password]
          .must_include 'password must be between 1 and 150 characters long'
      end

      it 'is at most 150 character long' do
        user = User::Member.new(password: 'a' * 151)
        user.valid?.must_equal false
        user.errors[:password]
          .must_include 'password must be between 1 and 150 characters long'
      end
    end #password
  end # validations
end # User::Member
