# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require 'Tinto/Exceptions'
require_relative '../../../../Resources/Workspace/Invitation/Enforcer'
require_relative '../../../../Services/Tracker'


include Belinkr
include Tinto::Exceptions

describe Workspace::Invitation::Enforcer do
  before do
    @workspace      = OpenStruct.new(id: 0)
    @invitation     = OpenStruct.new(id: 0)
    @tracker        = Workspace::Tracker
                        .new(Workspace::Tracker::MemoryBackend.new)
    @enforcer       = Workspace::Invitation::Enforcer
                        .new(@workspace, @invitation, @tracker)

    @not_involved   = OpenStruct.new(id: 2)

    @actor          = OpenStruct.new(id: 1)
    @collaborator   = OpenStruct.new(id: 3)
    @invited        = OpenStruct.new(id: 4)
    @autoinvited    = OpenStruct.new(id: 5)

    @tracker.register(@workspace, @actor, :collaborator)
    @tracker.register(@workspace, @collaborator, :collaborator)
    @tracker.register(@workspace, @invited, :invited)
    @tracker.register(@workspace, @autoinvited, :autoinvited)
  end

  describe '#invite' do
    it 'raises if the actor is not in the workspace' do
      lambda { @enforcer.invite(@not_involved, @not_involved) }
        .must_raise NotAllowed
    end

    it 'raises if the invited is already in the workspace' do
      lambda { @enforcer.invite(@actor, @collaborator) }.must_raise NotAllowed
    end
    
    it 'raises if the invited is already invited' do
      lambda { @enforcer.invite(@actor, @invited) }.must_raise NotAllowed
    end
    
    it 'raises if the invited is already autoinvited' do
      lambda { @enforcer.invite(@actor, @autoinvited) }.must_raise NotAllowed
    end
  end

  describe '#accept' do
    it 'raises if the actor is already in the workspace' do
      lambda { @enforcer.accept(@actor, @collaborator) }.must_raise NotAllowed
    end
  end

  describe '#reject' do
    it 'raises if the actor is already in the workspace' do
      lambda { @enforcer.reject(@actor, @collaborator) }.must_raise NotAllowed
    end
  end
end # Workspace::Invitation::Enforcer

