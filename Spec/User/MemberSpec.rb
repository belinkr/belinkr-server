# encoding: utf-8
require 'minitest/autorun'
require_relative '../../Locales/Loader'
require_relative '../../App/User/Member'
require_relative '../../Tinto/Exceptions'

include Belinkr
include Tinto::Exceptions

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
        name_orders = User::Member::NAME_ORDERS.join(', ')
        user = User::Member.new(name_order: 'invalid')
        user.valid?.must_equal false
        user.errors[:name_order]
          .must_include "name order must be one of #{name_orders}"

        user = User::Member.new(name_order: 'first-last')
        user.valid?.must_equal false
        user.errors[:name_order].must_be_empty

        user = User::Member.new(name_order: 'last-first')
        user.valid?.must_equal false
        user.errors[:name_order].must_be_empty
      end
    end # name_order

    describe '#password' do
      it 'at least 1 character long' do
        user = User::Member.new
        user.instance_variable_set :'@password', nil
        user.valid?.must_equal false
        user.errors[:password]
          .must_include 'password must be between 1 and 150 characters long'
      end

      it 'is at most 150 character long' do
        user = User::Member.new
        user.instance_variable_set :'@password', nil
        user.valid?.must_equal false
        user.errors[:password]
          .must_include 'password must be between 1 and 150 characters long'
      end
    end #password
  end # validations

  describe '#name' do
    it 'is initialized to the localized name according to the name order' do
      user = User::Member.new(first: 'John', last: 'Doe')
      user.name.must_equal 'John Doe'

      user = User::Member
              .new(first: 'John', last: 'Doe', name_order: 'first-last')
      user.name.must_equal 'John Doe'

      user = User::Member
              .new(first: 'John', last: 'Doe', name_order: 'last-first')
      user.name.must_equal 'Doe John'
    end
  end #name
 
  describe '#register_in' do
    it 'registers the email and id in the locator service' do
      user = User::Member.new(
        first:    'John',
        last:     'Doe', 
        email:    'jdoe@foo.com',
        password: 'changeme'
      )

      user_locator = Minitest::Mock.new

      user_locator.expect :add, user_locator, [user.email, user.id]
      user.register_in(user_locator)
      user_locator.verify
    end

    it 'raises if user invaid' do
      user          = User::Member.new
      user_locator  = Minitest::Mock.new

      user_locator.expect :add, user_locator, [user.email, user.id]
      lambda { user.register_in(user_locator) }.must_raise InvalidMember
    end 
  end #register_in
end # User::Member
