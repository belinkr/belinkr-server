# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require 'set'
require_relative '../../../Resources/Workspace/Enforcer'
require 'Tinto/Exceptions'

include Belinkr
include Tinto::Exceptions

describe Workspace::Enforcer do
  describe '#initialize' do
    it 'requires collections of administrators and collaborators' do
      lambda { Workspace::Enforcer.new }.must_raise ArgumentError
      lambda { Workspace::Enforcer.new administrators: [] }.must_raise KeyError
      Workspace::Enforcer.new administrators: [], collaborators: []
    end #initialize
  end #initialize

  describe '#authorize' do
    describe 'for a workspace administrator' do
      it 'allows all actions' do
        administrator   = OpenStruct.new(id: '8')
        administrators  = Set.new([administrator])
        enforcer        = Workspace::Enforcer.new(
                            administrators: administrators,
                            collaborators: Set.new
                          )

        Workspace::Enforcer::ACTIONS.each do |action|
          enforcer.authorize(administrator, action).must_equal true
        end
      end
    end # for an administrator

    describe 'for a collaborator' do
      it 'raises for update, delete, undelete, promote, demote and remove' do
        collaborator    = OpenStruct.new(id: '8')
        collaborators   = Set.new([collaborator])
        enforcer        = Workspace::Enforcer.new(
                            administrators: Set.new,
                            collaborators: collaborators
                          )


        Workspace::Enforcer::ADMINISTRATOR_ACTIONS.each do |action|
          lambda { enforcer.authorize(collaborator, action) }
            .must_raise NotAllowed
        end
      end
    end # for a collaborator

    describe 'for a non involved user' do
      it 'raises for all actions' do
        not_involved  = OpenStruct.new(id: '8')
        enforcer      = Workspace::Enforcer.new(
                          administrators: Set.new,
                          collaborators: Set.new
                        )

        Workspace::Enforcer::ACTIONS.each do |action|
          lambda { enforcer.authorize(not_involved, action) }
            .must_raise NotAllowed
        end
      end
    end # for a non involved user
  end #authorize
end # Workspace::Enforcer

