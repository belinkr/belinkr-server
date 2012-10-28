require 'minitest/autorun'
require 'ostruct'
require_relative '../../../App/User/Locator/Buffer'

include Belinkr

describe User::Locator::Buffer do
  before do 
    @locator  = User::Locator::Buffer.new
    @user    = OpenStruct.new(id: 1)
  end

  describe '#add' do
    it 'adds a key and user_id pair to the locator service' do
      @locator.add 'user@belinkr.com', @user.id
      @locator.keys.length.must_equal 1
      @locator.ids.length.must_equal 1
    end
  end #add

  describe '#delete' do
    it 'deletes the user_id and all keys from the maps' do
      @locator.add 'user@belinkr.com', @user.id
      @locator.add 'user', @user.id
      @locator.keys_for(@user.id).wont_be_empty

      @locator.delete(@user.id)

      @locator.keys_for(@user.id).must_be_empty
      lambda { @locator.id_for('user@belinkr.com') }.must_raise KeyError
      lambda { @locator.id_for('user') }.must_raise KeyError
    end
  end #delete

  describe '#id_for' do
    it 'retrieves a user from a key' do
      @locator.add 'user@belinkr.com', @user.id
      @locator.id_for('user@belinkr.com').must_equal @user.id
    end

    it 'retrieves the same user if it is referenced by two different keys' do
      @locator.add 'user@belinkr.com', @user.id
      @locator.add 'user', @user.id
      
      @locator.id_for('user@belinkr.com').must_equal @locator.id_for('user')
      @locator.keys.length.must_equal 2
      @locator.ids.length.must_equal 1 
    end
  end #id_for

  describe '#keys_for' do
    it 'returns all keys for a given user id' do
      @locator.add 'user@belinkr.com', @user.id
      @locator.add 'user', @user.id
      @locator.keys_for(@user.id).length.must_equal 2
    end

    it 'returns an empty array if no matches' do
      @locator.keys_for(@user.id).length.must_equal 0
    end
  end #keys_for

  describe 'registered?' do
    it 'returns true if user is registered in the locator service'do
      @locator.registered?(@user.id).must_equal false
      @locator.add 'user@belinkr.com', @user.id
      @locator.registered?(@user.id).must_equal true
    end
  end #registered?
end # Locator::Buffer
