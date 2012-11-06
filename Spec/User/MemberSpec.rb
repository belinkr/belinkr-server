# encoding: utf-8
require 'minitest/autorun'
require_relative '../../Locales/Loader'
require_relative '../../App/User/Member'
require_relative '../../App/Profile/Member'
require_relative '../../Tinto/Exceptions'

include Belinkr
include Tinto::Exceptions

describe User::Member do
  before do
    @valid_user = User::Member.new(
                    first: 'John', 
                    last: 'Doe', 
                    email: 'jdoe@belinkr.com',
                    password: 'changeme'
                  )
  end
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
    it 'returns a full name following the name order' do
      User::Member.new(first: 'John', last: 'Doe') 
        .name.must_equal 'John Doe'

      User::Member.new(first: 'John', last: 'Doe', name_order: 'first-last')
        .name.must_equal 'John Doe'

      User::Member.new(first: 'John', last: 'Doe', name_order: 'last-first')
        .name.must_equal 'Doe John'
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

    it 'raises if user invalid' do
      user          = User::Member.new
      user_locator  = Minitest::Mock.new

      user_locator.expect :add, user_locator, [user.email, user.id]
      lambda { user.register_in(user_locator) }.must_raise InvalidMember
    end 
  end #register_in

  describe '#unregister_from' do
    it 'unregisters the email and id in the locator service' do
      user = User::Member.new(
        first:    'John',
        last:     'Doe', 
        email:    'jdoe@foo.com',
        password: 'changeme'
      )

      user_locator = Minitest::Mock.new

      user_locator.expect :delete, user_locator, [user.email, user.id]
      user.unregister_from(user_locator)
      user_locator.verify
    end

    it 'raises if user invalid' do
      user          = User::Member.new
      user_locator  = Minitest::Mock.new

      user_locator.expect :add, user_locator, [user.email, user.id]
      lambda { user.unregister_from(user_locator) }.must_raise InvalidMember
    end
  end #unregister_from

  describe '#link_to' do
    it 'links the profile and the user' do
      user    = User::Member.new
      profile = Profile::Member.new

      user.link_to(profile)
      profile.user_id.must_equal user.id
      user.profiles.must_include profile
    end
  end #link_to

  describe '#unlink_from' do
    it 'unlinks the profile from the user' do
      profile = Profile::Member.new

      @valid_user.link_to(profile)
      profile.user_id.must_equal @valid_user.id
      @valid_user.profiles.must_include profile

      @valid_user.unlink_from(profile)
      @valid_user.profiles.wont_include profile
    end #unlink_from

    it 'deletes the user if no more profiles left' do
      profile = Profile::Member.new

      @valid_user.link_to(profile)
      profile.user_id.must_equal @valid_user.id
      @valid_user.profiles.must_include profile

      @valid_user.deleted_at.must_be_nil
      @valid_user.unlink_from(profile)
      @valid_user.deleted_at.wont_be_nil
    end
  end #unlink

  describe '#authenticate' do
    it 'returns an authenticated session' do
      plaintext = 'changeme'
      session   = OpenStruct.new
      profile   = Profile::Member.new(entity_id: 1)
      user      = User::Member.new(password: plaintext, profiles: [profile])

      user.authenticate(session, plaintext)

      session.user_id     .must_equal user.id
      session.profile_id  .must_equal profile.id
      session.entity_id   .must_equal profile.entity_id
    end

    it 'raises if plaintext does not match user password' do
      user    = User::Member.new(password: 'secret')
      session = OpenStruct.new

      lambda { user.authenticate(session, 'wrong') }.must_raise NotAllowed
    end

    it 'raises if user is deleted' do
      user    = User::Member.new(password: 'secret', deleted_at: Time.now)
      session = OpenStruct.new
      lambda { user.authenticate(session, 'secret') }.must_raise NotAllowed
    end
  end #authenticate

  describe '#update_details' do
    it 'requires a profile, user_changes and profile_changes' do
      profile         = Profile::Member.new
      user_changes    = { password: 'changed' }
      profile_changes = { mobile: 'changed' } 

      lambda { @valid_user.update_details }.must_raise ArgumentError
      lambda { @valid_user.update_details(profile: OpenStruct.new) }
        .must_raise KeyError

      @valid_user.update_details(
        profile:          profile, 
        user_changes:     user_changes,
        profile_changes:  profile_changes
      )
    end

    it 'updates user details' do
      profile         = Profile::Member.new
      user_changes    = { password: 'changed' }
      profile_changes = { mobile: 'changed' } 

      old_password = @valid_user.password

      @valid_user.update_details(
        profile:          profile, 
        user_changes:     user_changes,
        profile_changes:  profile_changes
      )

      @valid_user.password.wont_equal old_password
      @valid_user.password.wont_equal 'changed'
    end

    it 'updates profile details' do
      profile         = Profile::Member.new
      user_changes    = { password: 'changed' }
      profile_changes = { mobile: 'changed' } 

      @valid_user.update_details(
        profile:          profile, 
        user_changes:     user_changes,
        profile_changes:  profile_changes
      )

      profile.mobile.must_equal 'changed'
    end
  end #update_details
end # User::Member

