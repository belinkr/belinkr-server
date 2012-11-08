# encoding: utf-8
require 'minitest/autorun'
require_relative '../../../Locales/Loader'
require_relative '../../../Data/Scrapbook/Member'

include Belinkr

describe Scrapbook::Member do
  describe 'validations' do
    describe '#name' do
      it 'must be present' do
        scrapbook = Scrapbook::Member.new
        scrapbook.valid?.must_equal false
        scrapbook.errors[:name].must_include 'name must not be blank'
      end

      it 'has minimum length of 1 character' do
        scrapbook = Scrapbook::Member.new(name: '')
        scrapbook.valid?.must_equal false
        scrapbook.errors[:name]
          .must_include 'name must be between 1 and 250 characters long'
      end

      it 'has maximum length of 250 characters' do
        scrapbook = Scrapbook::Member.new(name: 'a' * 251)
        scrapbook.valid?.must_equal false
        scrapbook.errors[:name]
          .must_include 'name must be between 1 and 250 characters long'
      end
    end #name
      
    describe '#user_id' do
      it 'must be present' do
        scrapbook = Scrapbook::Member.new
        scrapbook.valid?.must_equal false
        scrapbook.errors[:user_id].must_include 'user must not be blank'
      end
    end #user_id
  end # validations

  describe '#link_to' do
    it 'links the scrapbook to the user' do
      actor     = OpenStruct.new(id: 8)
      scrapbook = Scrapbook::Member.new

      scrapbook.link_to(actor)
      scrapbook.user_id.must_equal actor.id.to_s
    end
  end #link_to
end # Scrapbook::Member
