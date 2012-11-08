# encoding: utf-8
require 'minitest/autorun'
require_relative '../../../Locales/Loader'
require_relative '../../../Data/Workspace/Member'
require_relative '../../../Tinto/Exceptions'

include Belinkr
include Tinto::Exceptions

describe Workspace::Member do
  describe 'validations' do
    describe '#name' do
      it 'must be present' do
        workspace = Workspace::Member.new
        workspace.valid?.must_equal false
        workspace.errors[:name].must_include 'name must not be blank'
      end

      it 'has minimum length of 1 characters' do
        workspace = Workspace::Member.new(name: '')
        workspace.valid?.must_equal false
        workspace.errors[:name]
          .must_include 'name must be between 1 and 250 characters long'
      end

      it 'has maximum length of 250 characters' do
        workspace = Workspace::Member.new(name: 'a' * 251)
        workspace.valid?.must_equal false
        workspace.errors[:name]
          .must_include 'name must be between 1 and 250 characters long'
      end
    end #name

    describe 'entity_id' do
      it 'must be present' do
        workspace = Workspace::Member.new
        workspace.valid?.must_equal false
        workspace.errors[:entity_id].must_include 'entity must not be blank'
      end
    end #entity_id
  end # validations

  describe '#link_to' do
    it 'links the workspace to the entity' do
      workspace = Workspace::Member.new
      entity    = OpenStruct.new(id: 8)

      workspace.link_to(entity)
      workspace.entity_id.must_equal entity.id.to_s
    end
  end #link_to
end # Workspace::Member

