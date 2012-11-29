# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require 'Tinto/Exceptions'
require_relative '../../../../Resources/Workspace/Autoinvitation/Enforcer'
require_relative '../../../../Services/Tracker'


include Belinkr
include Tinto::Exceptions

describe Workspace::Autoinvitation::Enforcer do
  before do
    @workspace      = OpenStruct.new(id: 0)
    @autoinvitation = OpenStruct.new(id: 0)
    @tracker        = Workspace::Tracker
                        .new(Workspace::Tracker::MemoryBackend.new)
    @enforcer       = Workspace::Autoinvitation::Enforcer
                        .new(@workspace, @autoinvitation, @tracker)

    @not_involved   = OpenStruct.new(id: 2)
    @collaborator   = OpenStruct.new(id: 3)
    @invited        = OpenStruct.new(id: 4)
    @autoinvited    = OpenStruct.new(id: 5)

    @tracker.register(@workspace, @collaborator, :collaborator)
    @tracker.register(@workspace, @invited, :invited)
    @tracker.register(@workspace, @autoinvited, :autoinvited)
  end

  describe '#autoinvite' do
    it 'raises if the actor is already in the workspace' do
      lambda { @enforcer.autoinvite(@collaborator) }.must_raise NotAllowed
    end

    it 'raises if the actor is already invited' do
      lambda { @enforcer.autoinvite(@invited) }.must_raise NotAllowed
    end
    
    it 'raises if the actor is already autoinvited' do
      lambda { @enforcer.autoinvite(@autoinvited) }.must_raise NotAllowed
    end
  end

  describe '#accept' do
    it 'raises unless the actor is already in the workspace' do
      lambda { @enforcer.accept(@not_involved, @not_involved) }
        .must_raise NotAllowed
    end

    it 'raises if the autoinvited is already in the workspace' do
      lambda { @enforcer.accept(@collaborator, @collaborator) }
        .must_raise NotAllowed
    end
  end

  describe '#reject' do
    it 'raises unless the actor is already in the workspace' do
      lambda { @enforcer.reject(@not_involved, @not_involved) }
        .must_raise NotAllowed
    end

    it 'raises if the autoinvited is already in the workspace' do
      lambda { @enforcer.reject(@collaborator, @collaborator) }
        .must_raise NotAllowed
    end
  end
end # Workspace::Autoinvitation::Enforcer

