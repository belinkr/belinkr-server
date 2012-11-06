# encoding: utf-8
require 'minitest/autorun'
require 'ostruct'
require_relative '../../App/User/Enforcer'
require_relative '../../Tinto/Exceptions'

include Belinkr
include Tinto::Exceptions

describe User::Enforcer do
  describe '#initialize' do
    it 'requires a user' do
      lambda { User::Enforcer.new }.must_raise ArgumentError
      User::Enforcer.new(OpenStruct.new)
    end
  end #initialize

  describe '#authorize' do
    it 'raises unless the actor is the same as the user' do
      user      = OpenStruct.new(id: 8)
      enforcer  = User::Enforcer.new(user)

      lambda { enforcer.authorize(OpenStruct.new(id: 5), 'update') }
        .must_raise NotAllowed
      enforcer.authorize(OpenStruct.new(id: 8), 'update').must_equal true
    end #authorize
  end #authorize
end # User::Enforcer

