# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require 'json'
require_relative '../../../Config'
require_relative '../../../Locales/Loader'
require_relative '../../../Resources/Polymorphic/Polymorphic'

include Belinkr

describe Polymorphic::Member do
  describe 'validations' do
    describe 'kind' do
      it 'must be present' do
        activity = Polymorphic::Member.new
        activity.valid?.must_equal false
        activity.errors[:kind].must_include 'kind must not be blank'
      end

      it 'must be a valid key for the class mapper' do
        activity  = Polymorphic::Member.new
        kinds     = Polymorphic::Member::MAP.keys.join(', ')

        activity.valid?.must_equal false
        activity.errors[:kind].must_include "kind must be one of #{kinds}"
      end
    end #kind

    describe 'resource' do
      it 'must be present' do
        activity = Polymorphic::Member.new
        activity.valid?.must_equal false
        activity.errors[:resource].must_include 'resource must not be blank'
      end
    end #resource

    describe 'resource=' do
      before do
        @resource = OpenStruct.new(name: 'resource 1')
        def @resource.to_hash; { name: self.name }; end
      end

      it 'assigns the resource' do
        activity          = Polymorphic::Member.new
        activity.resource = @resource
        activity.resource.name.must_equal @resource.name

        activity = Polymorphic::Member.new(resource: @resource)
        activity.resource.name.must_equal @resource.name
      end

      it 'detects the kind of resource and populates the kind attribute' do
        activity = Polymorphic::Member.new(resource: @resource)
        activity.kind.must_equal 'openstruct'
      end
    end
  end # validations

  describe '#to_json' do
    it 'renders a json representation of previewable attributes' do
      @resource = OpenStruct.new(
        name:                   'resource 1',
        non_previewable_field:  'whatever'
      )
      def @resource.to_hash; marshal_dump; end

      workspace = Polymorphic::Member.new
      workspace.resource = @resource

      workspace = Polymorphic::Member.new JSON.parse(workspace.to_json)
      workspace.resource.non_previewable_field  .must_be_nil
      workspace.resource.name                   .wont_be_nil
    end
  end #to_json
end # Polymorphic::Member
