# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../Config'
require_relative '../../Locales/Loader'
require_relative '../../App/Polymorphic/Polymorphic'

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
end # Polymorphic::Member
