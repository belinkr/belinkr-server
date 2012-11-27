# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../../Resources/Invitation/Enforcer'
require 'Tinto/Exceptions'

include Belinkr
include Tinto::Exceptions

describe Invitation::Enforcer do
  describe '#initialize' do
    it 'requires an invitation' do
      lambda { Invitation::Enforcer.new }.must_raise ArgumentError
      Invitation::Enforcer.new(OpenStruct.new)
    end
  end #initialize

  describe '#authorize' do
    it 'raises unless the actor is the same as the inviter' do
      invitation  = OpenStruct.new(inviter_id: 8)
      enforcer    = Invitation::Enforcer.new(invitation)

      lambda { enforcer.authorize(OpenStruct.new(id: 5), 'update') }
        .must_raise NotAllowed
      enforcer.authorize(OpenStruct.new(id: 8), 'update').must_equal true
    end #authorize
  end #authorize
end # Invitation::Enforcer

