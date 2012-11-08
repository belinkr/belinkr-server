# encoding: utf-8
require 'minitest/autorun'
require_relative '../../../Locales/Loader'
require_relative '../../../Data/Reset/Member'

include Belinkr

describe Reset::Member do
  describe 'validations' do
    describe '#id' do
      it 'must be present' do
        reset     = Reset::Member.new
        reset.id  = nil
        reset.valid?.must_equal false
        reset.errors[:id].must_include 'id must not be blank'
      end
    end #id

    describe '#email' do
      it 'must be present' do
        reset = Reset::Member.new
        reset.valid?.must_equal false
        reset.errors[:email].must_include 'e-mail must not be blank'
      end

      it 'must be in a valid format' do
        reset = Reset::Member.new(email: 'foo')
        reset.valid?.must_equal false
        reset.errors[:email].must_include 'e-mail has an invalid format'
      end
    end #email
  end # validations

  describe '#link_to' do
    it 'links the reset to the actor' do
      reset = Reset::Member.new
      user  = OpenStruct.new(id: 8, email: 'user@gmail.com')

      reset.link_to(user)
      reset.email.must_equal user.email
      reset.user_id.must_equal user.id.to_s
    end #link_to
  end #link_to
end # Reset::Member
