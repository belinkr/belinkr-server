# encoding: utf-8
require 'minitest/autorun'
require_relative '../../../App/Workspace/Membership/Tracker'

include Belinkr::Workspace

describe Membership::Tracker do
  before do
    @entity_id    = 1
    @workspace_id = 2
    @tracker      = Membership::Tracker.new(@entity_id, @workspace_id)
  end

  describe '#add' do
    it 'adds a membership signature' do
      @tracker.add 'administrator', 5
      @tracker.size.must_equal 1
    end
  end #add

  describe '#delete' do
    it 'deletes a membership signature' do
      @tracker.add 'administrator', 5
      @tracker.size.must_equal 1
      @tracker.delete 'administrator', 5
      @tracker.size.must_equal 0
    end
  end #delete

  describe '#each' do
    it 'instantiates a Membership::Collection for each element' do
      @tracker.add 'administrator', 5
      memberships = @tracker.map.first
      memberships.must_be_instance_of Membership::Collection
      memberships.must_be :valid?
      memberships.kind      .must_equal 'administrator'
      memberships.user_id   .must_equal '5'
      memberships.entity_id .must_equal @entity_id.to_s
    end
  end #each
end

