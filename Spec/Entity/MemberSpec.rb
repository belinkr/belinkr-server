# encoding: utf-8
require 'minitest/autorun'
require_relative '../../Locales/Loader'
require_relative '../../App/Entity/Member'

include Belinkr

describe Entity::Member do
  describe 'validations' do
    describe 'name' do
      it 'must be present' do
        entity = Entity::Member.new
        entity.valid?.must_equal false
        entity.errors[:name].must_include 'name must not be blank'
      end

      it 'must be unique' do
        skip
      end

      it 'has at least 2 characters' do
        entity = Entity::Member.new(name: 'a')
        entity.valid?.must_equal false
        entity.errors[:name]
          .must_include 'name must be between 2 and 150 characters long'
      end

      it 'has at most 150 characters' do
        entity = Entity::Member.new(name: 'a' * 151)
        entity.valid?.must_equal false
        entity.errors[:name]
          .must_include 'name must be between 2 and 150 characters long'
      end
    end #name
  end # validations
end # Entity::Member
