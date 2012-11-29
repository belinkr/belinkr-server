# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require 'Tinto/Exceptions'
require_relative '../../../Resources/Workspace/Enforcer'
require_relative '../../../Services/Tracker'

include Belinkr
include Tinto::Exceptions

describe Workspace::Enforcer do
  before do
    @workspace      = OpenStruct.new(id: 0)
    @tracker        = Workspace::Tracker.new(Workspace::Tracker::MemoryBackend.new)

    @collaborator   = OpenStruct.new(id: 1)
    @administrator  = OpenStruct.new(id: 2)
    @not_involved   = OpenStruct.new(id: 3)

    @enforcer       = Workspace::Enforcer.new(@workspace, @tracker)
    @tracker.register(@workspace, @collaborator, :collaborator)
    @tracker.register(@workspace, @administrator, :administrator)
  end

  describe '#authorize' do
    describe 'for a workspace administrator' do
      it 'allows all actions' do
        Workspace::Enforcer::ACTIONS.each do |action|
          @enforcer.authorize(@administrator, action).must_equal true
        end
      end
    end # for an administrator

    describe 'for a collaborator' do
      it 'raises for update, delete, undelete, promote, demote and remove' do
        Workspace::Enforcer::ADMINISTRATOR_ACTIONS.each do |action|
          lambda { @enforcer.authorize(@collaborator, action) }
            .must_raise NotAllowed
        end
      end
    end # for a collaborator

    describe 'for a non involved user' do
      it 'raises for all actions' do
        Workspace::Enforcer::ACTIONS.each do |action|
          lambda { @enforcer.authorize(@not_involved, action) }
            .must_raise NotAllowed
        end
      end
    end # for a non involved user
  end #authorize
end # Workspace::Enforcer

